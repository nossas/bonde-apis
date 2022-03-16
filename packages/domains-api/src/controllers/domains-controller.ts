import logger from '../config/logger';
// import { check_user, Roles } from '../permissions';
import route53 from '../route53';
import { DNSRecord } from '../route53/types';

class DomainsController {
  client: any;
  DNSHostedZonesAPI: any;

  constructor(client, DNSHostedZonesAPI) {
    this.client = client;
    this.DNSHostedZonesAPI = DNSHostedZonesAPI;
  }

  createDomains = async (req, res) => {
    logger.info('In controller - createDomains');

    // Resolver create domain
    // const create_domain = async (_: void, args: Args): Promise<DNSHostedZonesAPI.DNSHostedZoneResult> => {
    const domain = req.body.domain;
    const comment = req.body.comment;
    const community_id = req.body.community_id;

    // Fetch DNSHostedZone
    const dnsHostedZones = await this.DNSHostedZonesAPI.find({ domain_name: { _eq: domain } }, this.client);
    logger.child({ dnsHostedZones }).info('fetch hosted zone');
    if (dnsHostedZones && dnsHostedZones.length > 0 && dnsHostedZones[0].community_id !== community_id) {
      throw new Error('domain_name_exists');
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

  deleteDomains = async (req, res) => {
    logger.info('In controller - deleteDomains');

    const dns_hosted_zone_id = req.body.dns_hosted_zone_id;

    try {
      const dnsHostedZone = await this.DNSHostedZonesAPI.get(dns_hosted_zone_id, this.client);
      const hostedZoneId = dnsHostedZone.hosted_zone.Id || dnsHostedZone.hosted_zone.id;

      logger.child({ dnsHostedZone }).info('delete_hosted_zone');
      await route53.delete_records({
        hostedZoneId,
        dnsRecords: dnsHostedZone.dns_records?.filter((r: any) => r.record_type !== 'NS' && r.record_type !== 'SOA')
      });
      await route53.delete_hosted_zone({ hostedZoneId });
      await this.DNSHostedZonesAPI.remove(dns_hosted_zone_id, this.client)

      res.json({ status: 'ok' });
    } catch (err) {
      logger.child({ err }).info('delete_hosted_zone');
      res.status(500).json(err);
    }

    // export default check_user(delete_domain, Roles.ADMIN);
    // res.json(dns_hosted_zone_id);
  };
}


export default DomainsController;
