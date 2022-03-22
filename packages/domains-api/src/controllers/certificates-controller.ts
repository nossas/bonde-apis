/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import logger from '../config/logger';
import { gql } from '../graphql-api/client';
import { validationResult, check } from 'express-validator';
import sslChecker from "ssl-checker";

interface Request<T> {
  body: {
    event: {
      data: {
        new: T
      }
    }
  }
}

interface Certificate {
  id: number;
  domain: string;
}

const insert_certificate = gql`mutation ($input: certificates_insert_input!) {
  insert_certificates_one(object:$input) {
    id
    dns_hosted_zone_id
    is_active
    community_id
    domain
  }
}
`;

const update_certificate = gql`
mutation ($id: Int!) {
  update_certificates_by_pk(pk_columns: { id: $id }, _set: { is_active: true }) {
    id
    dns_hosted_zone_id
    is_active
    community_id
  }
}
`;

class CertificatesController {
  private redisClient: any
  private graphqlClient: any

  constructor(redisClient, graphqlClient) {
    this.redisClient = redisClient;
    this.graphqlClient = graphqlClient;
  }

  create = async (req, res) => {
    await check('payload').isObject().run(req);
    // await check('password').isLength({ min: 6 }).run(req);
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    try {
      await this.insertCertificateRedis(req.body.payload.event.data.new);
      res.json(await this.insertCertificateGraphql(req.body.payload.event.data.new));
    } catch (e: any) {
      logger.info(e)
      res.status(500).json({ ok: false });
    }
  }

  private insertCertificateRedis = async (input: any) => {
    const { domain_name, id } = input;
    const tRouterName = `${id}-${domain_name.replace('.', '-')}`
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

  private insertCertificateGraphql = async (input: any) => {
    const { domain, community_id, dns_hosted_zone_id, id, is_active } = input;
    const data: any = await this.graphqlClient.request({
      document: insert_certificate,
      variables: { input: { domain, community_id, dns_hosted_zone_id, id, is_active: false } }
    });

    logger.child({ data }).info('insert_certificate.upsert');

    return data.insert_certificates_one;
  }

  private updateCertificateGraphql = async (id: number) => {
    const { data, errors }: any = await this.graphqlClient.request({
      document: update_certificate,
      variables: { id }
    });

    logger.child({ errors, data }).info('update_certificates');

    return data.update_certificates_by_pk;
  }

  check = async (req: Request<Certificate>, res) => {
    await check('email').isEmail().run(req);
    await check('password').isLength({ min: 6 }).run(req);
    /**
     * Esse evento deve ser chamado sempre que criar um novo certificado
     * Hasura irá fazer uma nova chamada em caso de erro no intervalo de 6 minutos
     * durante 20 tentativas
     */
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const certificate = req.body.event.data.new;
    logger.info(certificate);

    const checker = await sslChecker(certificate.domain);
    logger.info(checker);

    if (checker.valid) {
      await this.updateCertificateGraphql(certificate.id);
      res.json({ ok: true })
    } else {
      res.status(400).json({ errors: ['invalid_ssl_checker'] });
    }
  }
}

export default CertificatesController;