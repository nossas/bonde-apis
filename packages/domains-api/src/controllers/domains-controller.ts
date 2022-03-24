import { GraphQLClient } from 'graphql-request';
import logger from '../config/logger';
import { verify_permission } from '../config/validators';
import route53 from '../route53';
import { DNSRecord } from '../route53/types';
import * as DNSHostedZonesGraphQLAPI from '../graphql-api/dns_hosted_zones';
import { HasuraActionRequest } from '../types';

interface InputDomain {
  domain: {
    domain_name: string;
    community_id: number;
    comment?: string;
  }
}

interface InputDeleteDomain {
  domain: {
    dns_hosted_zone_id: number;
    community_id: number;
  }
}

class DomainsController {
  client: GraphQLClient;
  DNSHostedZonesAPI: typeof DNSHostedZonesGraphQLAPI;

  constructor(DNSHostedZonesAPI, client) {
    this.client = client;
    this.DNSHostedZonesAPI = DNSHostedZonesAPI;
  }

  createDomains = async (req: HasuraActionRequest<InputDomain>, res) => {
    logger.info('In controller - createDomains');

    const domain = req.body.input.domain.domain_name;
    const comment = req.body.input.domain.comment;
    const community_id = req.body.input.domain.community_id;
    
    logger.child(req.body).info('fetch hosted zone');

    // Fetch DNSHostedZone
    const dnsHostedZones = await this.DNSHostedZonesAPI.find({ domain }, this.client);

    
    if (dnsHostedZones && dnsHostedZones.length > 0 && dnsHostedZones[0].community_id !== community_id) {
      res.status(400).json('domain_name_exists');
    }

    // Create Hosted Zone on AWS
    const data = await route53.create_or_update_hosted_zone({ domain, comment });
    logger.child({ data }).info('create_or_update_hosted_zone');

    const dnsHostedZone = await this.DNSHostedZonesAPI.upsert({
      domain_name: domain,
      comment: comment,
      community_id: community_id,
      response: data
    }, this.client)

    logger.child({ dnsHostedZone }).info('DNSHostedZonesAPI.upsert');

    // Create Records default if not exists
    if (data.HostedZone.ResourceRecordSetCount === 2) {
      await route53.create_default_records({ domain, hostedZoneId: data.HostedZone.Id });
    }

    const records = await route53.fetch_records({ hostedZoneId: data.HostedZone.Id });
    await this.DNSHostedZonesAPI.records_upsert(
      records.map((r: DNSRecord) => ({
        ...r,
        name: r.name.replace('\\052', '*'),
        dns_hosted_zone_id: dnsHostedZone.id
      }))
      , this.client);
    // export default check_user(create_domain, Roles.ADMIN);
    res.json(dnsHostedZone);
  };

  deleteDomains = async (req: HasuraActionRequest<InputDeleteDomain>, res) => {
    /**
     * TODO
     * - remover certificado do REDIS
     * - verificar permissão com comunidade e usuário
     * 
     */
    logger.child({ payload: req.body }).info('In controller - deleteDomains');

    const dns_hosted_zone_id = req.body.input.domain.dns_hosted_zone_id;

    try {
      const dnsHostedZone = await this.DNSHostedZonesAPI.get(dns_hosted_zone_id, this.client);

      verify_permission(req.body.session_variables, dnsHostedZone.community, 'admin');

      const hostedZoneId = dnsHostedZone.hosted_zone.Id || dnsHostedZone.hosted_zone.id;

      logger.child({ dnsHostedZone }).info('delete_hosted_zone');

      await route53.delete_records({
        hostedZoneId,
        dnsRecords: dnsHostedZone.dns_records?.filter((r: any) => r.record_type !== 'NS' && r.record_type !== 'SOA')
      });

      await route53.delete_hosted_zone({ hostedZoneId });

      await this.DNSHostedZonesAPI.remove(dns_hosted_zone_id, this.client);

      res.json({ status: 'ok', id: dns_hosted_zone_id });
    } catch (err: any) {
      logger.child({ err }).info('delete_hosted_zone');
      res.status(400).json({
        message: err.message,
        extensions: err
      });
    }

    // export default check_user(delete_domain, Roles.ADMIN);
    // res.json(dns_hosted_zone_id);
  };
}

export default DomainsController;
