import logger from '../logger';
import route53 from '../route53';
import { check_user, Roles } from '../permissions';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';
import { DNSRecordResult } from '../graphql-api/dns_hosted_zones';

type Input = {
  dns_hosted_zone_id: number
  records: number[]
}

type Args = {
  input: Input
}

const delete_record = async (_: void, args: Args): Promise<void> => {
  const { input: { dns_hosted_zone_id, records } } = args;

  try {
    const dnsHostedZone = await DNSHostedZonesAPI.get(dns_hosted_zone_id);
    const hostedZoneId = dnsHostedZone.hosted_zone.Id || dnsHostedZone.hosted_zone.id;

    logger.child({ dnsHostedZone }).info('delete_hosted_zone');

    const delete_records: DNSRecordResult[] | undefined = dnsHostedZone.dns_records?.filter(
      (dr: any) => records.findIndex((r: any) => r.id === dr.id) !== -1)

    await route53.delete_records({
      hostedZoneId,
      dnsRecords: delete_records?.map((dr: DNSRecordResult) => ({
        type: dr.record_type,
        value: typeof dr.value === 'string' ? dr.value : dr.value.join(' '),
        name: dr.name,
        ttl: dr.ttl
      })) 
    });
    await route53.delete_hosted_zone({ hostedZoneId });
    await DNSHostedZonesAPI.remove(dns_hosted_zone_id)
  } catch (err) {
    logger.child({ err }).info('delete_hosted_zone');
  }
}

export default check_user(delete_record, Roles.ADMIN);