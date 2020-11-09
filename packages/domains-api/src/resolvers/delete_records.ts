import logger from '../logger';
import route53 from '../route53';
import { check_user, Roles } from '../permissions';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';
import { DNSRecordResult } from '../graphql-api/dns_hosted_zones';

type Input = {
  dns_hosted_zone_id: number
  records: number[]
  community_id: number
}

type Args = {
  input: Input
}

const delete_records = async (_: void, args: Args): Promise<void> => {
  const { input: { dns_hosted_zone_id, records } } = args;

  try {
    const dnsHostedZone = await DNSHostedZonesAPI.get(dns_hosted_zone_id);
    const hostedZoneId = dnsHostedZone.hosted_zone.Id || dnsHostedZone.hosted_zone.id;

    logger.child({ dnsHostedZone }).info('delete_hosted_zone');

    const delete_records: DNSRecordResult[] | undefined = dnsHostedZone.dns_records?.filter(
      (dr: any) => !!records.find((r: any) => r === dr.id));

    await route53.delete_records({
      hostedZoneId,
      dnsRecords: delete_records?.map((dr: DNSRecordResult) => {
        const dnsRecord = {
          record_type: dr.record_type,
          value: dr.value,
          name: dr.name.replace(/(\.)$/, ''),
          ttl: dr.ttl
        };

        logger.child({ dnsRecord }).info('delete_records');
        return dnsRecord;
      })
    });

    await DNSHostedZonesAPI.remove_records(records);
  } catch (err) {
    logger.child({ err }).info('delete_hosted_zone');
  }
}

export default check_user(delete_records, Roles.ADMIN);