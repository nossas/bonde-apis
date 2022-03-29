/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import logger from '../config/logger';
import { gql } from '../graphql-api/client';
import { validationResult, check } from 'express-validator';
import sslChecker from "ssl-checker";

export interface Request<T> {
  body: {
    event: {
      data: {
        new: T
      }
    }
  }
}

export interface CertificateTLS {
  id: number;
  dns_hosted_zone_id: number;
  is_active: boolean;
  community_id: number;
  domain: string;
  ssl_checker_response?: any;
}

export interface DNSHostedZone {
  id: number;
  community_id: number;
  domain_name: string;
  ns_ok?: boolean;
}

const insert_certificate = gql`mutation ($input: certificates_insert_input!) {
  insert_certificates_one(object:$input) {
    id
    dns_hosted_zone_id
    is_active
    community_id
    domain
    ssl_checker_response
  }
}
`;

const update_certificate = gql`
mutation ($id: Int!, $ssl_checker_response: jsonb) {
  update_certificates_by_pk(pk_columns: { id: $id }, _set: { is_active: true, ssl_checker_response: $ssl_checker_response }) {
    id
    dns_hosted_zone_id
    is_active
    community_id
    domain
    ssl_checker_response
  }
}
`;

`
query {
  mobilizations (where:{custom_domain:{_ilike:"%minhasampa.org.br"}}) {
    id, custom_domain
  }
}
`

class CertificatesController {
  private redisClient: any
  private graphqlClient: any

  constructor(redisClient, graphqlClient) {
    this.redisClient = redisClient;
    this.graphqlClient = graphqlClient;
  }

  create = async (req: Request<DNSHostedZone>, res) => {
    await check('event').isObject().run(req);
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    if (req.body.event.data.new.ns_ok) {
      try {
        await this.insertCertificateRedis(req.body.event.data.new);
        res.status(200).json(await this.insertCertificateGraphql(req.body.event.data.new));
      } catch (e: any) {
        logger.info(e)
        res.status(500).json({ ok: false, ...e });
      }
    } else {
      res.status(402).json({ message: 'Certificate not created because ns_ok is false.' });
    }
  }

  private insertCertificateRedis = async (input: any) => {
    const { domain_name, id: dns_hosted_zone_id } = input;
    const tRouterName = `${dns_hosted_zone_id}-${domain_name.replace('.', '-')}`
    logger.info(`In controller - createCertificate ${tRouterName}`);

    await this.redisClient.connect();
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls`, 'true');
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/certresolver`, 'myresolver');
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/rule`, `HostRegexp(\`${domain_name}\`, \`{subdomain:.+}.${domain_name}\`)`);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/domains/0/main`, domain_name);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/domains/0/sans/0`, `*.${domain_name}`);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/service`, 'public@docker');
    // console.log(await this.redisClient.get('traefik'));
    await this.redisClient.quit();
  }

  private insertCertificateGraphql = async (input: any): Promise<CertificateTLS> => {
    const { domain_name: domain, community_id, id: dns_hosted_zone_id } = input;
    const data: any = await this.graphqlClient.request({
      document: insert_certificate,
      variables: { input: { domain, community_id, dns_hosted_zone_id, is_active: false } }
    });

    logger.child({ data }).info('insert_certificate.upsert');

    return data.insert_certificates_one;
  }

  private updateCertificateGraphql = async (id: number, ssl_checker_response: any) => {
    const data = await this.graphqlClient.request({
      document: update_certificate,
      variables: { id, ssl_checker_response }
    });

    logger.child({ data }).info('update_certificates');

    return data.update_certificates_by_pk;
  }

  check = async (req: Request<CertificateTLS>, res) => {
    /**
     * Esse evento deve ser chamado sempre que criar um novo certificado
     * Hasura irá fazer uma nova chamada em caso de erro no intervalo de 6 minutos
     * durante 20 tentativas
     */
    try {
      await check('event').isObject().run(req);
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const certificate = req.body.event.data.new;
      logger.info(certificate);

      const checker = await sslChecker(certificate.domain);
      logger.info(checker);

      if (checker.valid) {
        res.json(await this.updateCertificateGraphql(certificate.id, checker));
      } else {
        res.status(400).json({ errors: ['invalid_ssl_checker'] });
      }
    } catch (e: any) {
      logger.info(e)
      res.status(500).json({ ok: false, ...e });
    }
  }
}

export default CertificatesController;