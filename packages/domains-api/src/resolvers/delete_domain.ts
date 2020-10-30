import logger from '../logger';
import route53 from '../route53';
import { check_user, Roles } from '../permissions';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

type Input = {
  dns_hosted_zone_id: number
}

type Args = {
  input: Input
}

const delete_domain = async (_: void, args: Args): Promise<void> => {
  const { input: { dns_hosted_zone_id } } = args;

  try {
    const dnsHostedZone = await DNSHostedZonesAPI.get(dns_hosted_zone_id);
    const hostedZoneId = dnsHostedZone.hosted_zone.Id || dnsHostedZone.hosted_zone.id;

    logger.child({ dnsHostedZone }).info('delete_hosted_zone');
    await route53.delete_records({
      hostedZoneId,
      dnsRecords: dnsHostedZone.dns_records?.filter((r: any) => r.record_type !== 'NS' && r.record_type !== 'SOA')
    });
    await route53.delete_hosted_zone({ hostedZoneId });
    await DNSHostedZonesAPI.remove(dns_hosted_zone_id)
  } catch (err) {
    logger.child({ err }).info('delete_hosted_zone');
  }
}

export default check_user(delete_domain, Roles.ADMIN);