// import * as recipients from '../graphql-api/recipients';
import logger from '../logger';
import { check_user, Roles } from '../permissions';
import route53 from '../route53';
import { DNSRecord } from '../route53/types';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

type RecordInput = {
  value: string
  name: string
  ttl: number
  record_type: string
  hosted_zone_id: string
  community_id: number
  dns_hosted_zone_id: number
}

type Args = {
  input: RecordInput
}

// Resolver create domain
const create_record = async (_: void, args: Args): Promise<void> => {
  const { input: { value, name, ttl, record_type, hosted_zone_id, dns_hosted_zone_id } } = args;
  
  try {
    const records = await route53.create_record({ value, name, ttl, record_type, hosted_zone_id });
    const objects = [{ value, name, ttl, record_type }].map((r: DNSRecord) => ({
      ...r,
      name: r.name.replace('\\052', '*'),
      dns_hosted_zone_id: dns_hosted_zone_id
    }))
    await DNSHostedZonesAPI.records_upsert(objects);
    
    logger.child({ objects, records }).info('create_record');
  } catch (err) {
    logger.child({ err }).info('create_record');
  }
}

export default check_user(create_record, Roles.ADMIN);