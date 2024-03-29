/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import logger from '../config/logger';
import { gql } from '../graphql-api/client';
import { createRouters, createWildcard, getRouters } from '../etcd-db/certificates';
import { HasuraActionRequest } from '../types';
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
  is_external_domain: boolean;
  ns_ok?: boolean;
}

export interface Mobilization {
  id: number;
  custom_domain: string;
  community_id: number;
}

interface InputCertificate {
  dns_hosted_zone_id: number;
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

export const fetch_mobilizations_by_domain = gql`
  query ($domainName: String) {
    mobilizations (where:{ custom_domain:{ _ilike: $domainName } }) {
      id
      custom_domain
      community_id
    }
  }
`;

export const get_cerificate = gql`
  query ($id: Int!) {
    certificate: certificates_by_pk(id: $id) {
      id
      domain
      is_active
      dns_hosted_zone_id
    }
  }
`

export const get_domain = gql`
  query ($id: Int!) {
    dns_hosted_zones_by_pk(id: $id) {
      id
      domain_name
      is_external_domain
      ns_ok
      certificates {
        id
        domain
        created_at
        is_active
        dns_hosted_zone_id
      }
    }
  }
`

class CertificatesController {
  private graphqlClient: any;

  constructor(graphqlClient) {
    this.graphqlClient = graphqlClient;
  }

  create = async (req: Request<DNSHostedZone>, res) => {
    if (!req.body.event) {
      await check('event').isObject().run(req);
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }
    }

    const dns_hosted_zone = req.body.event.data.new;

    if (dns_hosted_zone.ns_ok) {
      try {
        const domains: string[] = await this.fetchCustomDomains(dns_hosted_zone.domain_name);
        await this.insertCertificateRedis(dns_hosted_zone, domains);
        res.status(200).json(await this.insertCertificateGraphql(dns_hosted_zone));
      } catch (e: any) {
        logger.info(e)
        res.status(500).json({ ok: false, ...e });
      }
    } else {
      res.status(402).json({ message: 'Certificate not created because ns_ok is false.' });
    }
  }

  private insertCertificateRedis = async (input: DNSHostedZone, domains: string[]) => {
    const { domain_name, id: dns_hosted_zone_id, is_external_domain } = input;
    const tRouterName = `${dns_hosted_zone_id}-${domain_name.replace(/\./g, '-')}`
    logger.info(`In controller - createCertificate ${tRouterName}`);
    
    if (!is_external_domain) {
      await createWildcard(tRouterName, domain_name);
      await createRouters(`${tRouterName}-www`, domains);
    } else {
      await createRouters(`${tRouterName}-external`, domains.length > 0 ? [...domains, domain_name] : [`www.${domain_name}`, domain_name]);
    }
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

  private fetchCustomDomains = async (domain: string): Promise<string[]> => {
    const data: { mobilizations: Mobilization[] } = await this.graphqlClient.request({
      document: fetch_mobilizations_by_domain,
      variables: { domainName: `%${domain}%` }
    });

    logger.child({ data }).info('fetch_mobilizations_by_domain');

    return data.mobilizations.filter((mob) => mob.custom_domain !== `www.${domain}`).map((mob) => mob.custom_domain);
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

  private getCertificate = async (dns_hosted_zone_id: number): Promise<{ id: number, domain: string, is_active: boolean, dns_hosted_zone_id: number }> => {
    const data = await this.graphqlClient.request({
      document: get_cerificate,
      variables: { id: dns_hosted_zone_id }
    });

    if (!data?.certificate) throw new Error('certificate not found');
    
    logger.child({ data }).info('get_cerificate');

    return data.certificate;
  }

  update = async (req: HasuraActionRequest<InputCertificate>, res: any) => {
    try {
      const certificate = await this.getCertificate(req.body.input.dns_hosted_zone_id);
      const domains = await this.fetchCustomDomains(certificate.domain)
  
      const tRouterName = `${certificate.dns_hosted_zone_id}-${certificate.domain.replace(/\./g, '-')}`
      
      await createWildcard(tRouterName, certificate.domain);
      await createRouters(`${tRouterName}-www`, domains);
  
      res.json(certificate);
    } catch (e: any) {
      logger.info(e)
      res.status(400).json({ message: e.message });
    }
  }

  create_or_update = async (req: HasuraActionRequest<InputCertificate>, res?: any) => {
    try {
      const data = await this.graphqlClient.request({
        document: get_domain,
        variables: { id: req.body.input.dns_hosted_zone_id }
      });

      const hostedZone = data?.dns_hosted_zones_by_pk;

      if (!hostedZone) throw new Error('domain_not_found');
      if (!hostedZone.ns_ok) throw new Error('domain_not_propagated');

      if (hostedZone.certificates.length === 0) {
        const req: any = {
          body: {
            event: {
              data: {
                new: hostedZone
              }
            }
          }
        };
        return await this.create(req, res);
      }

      const [wildcard, routers] = await getRouters(data.dns_hosted_zones_by_pk.id, data.dns_hosted_zones_by_pk.domain_name);
      const customDomains = await this.fetchCustomDomains(data.dns_hosted_zones_by_pk.domain_name);

      const tRouterName = `${hostedZone.id}-${hostedZone.domain_name.replace(/\./g, '-')}`;
      if (!wildcard) {
        logger.child({ routerName: tRouterName }).info('create_or_update#createWildcard');
        await createWildcard(tRouterName, hostedZone.domain_name);
      }
      if (JSON.stringify(routers.sort()) !== JSON.stringify(customDomains.sort())) {
        logger.child({
          routerName: tRouterName,
          routers: JSON.stringify(routers.sort()),
          customDomain: JSON.stringify(customDomains.sort())
        }).info('create_or_update#createRouters');
        await createRouters(`${tRouterName}-www`, customDomains);
      }

      res?.json(hostedZone.certificates[0]);
    } catch (e: any) {
      logger.info(e);
      res?.status(400).json({ message: e.message });
    }
  }
}

export default CertificatesController;