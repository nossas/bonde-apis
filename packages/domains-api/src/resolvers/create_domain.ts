// import * as recipients from '../graphql-api/recipients';
import logger from '../logger';
import config from '../config';
import { check_user, Roles } from '../permissions';
import route53 from '../route53';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

type DomainInput = {
  domain: string
  comment?: string
  community_id: number
}

type Args = {
  input: DomainInput
}

// Resolver create domain
const create_domain = async (_: void, args: Args): Promise<DNSHostedZonesAPI.DNSHostedZoneResult> => {
  const { input: { domain, comment, community_id } } = args;
  
  // Create Hosted Zone on AWS
  const data = await route53.create_or_update_hosted_zone({ domain, comment });
  logger.child({ data }).info('create_or_update_hosted_zone');

  const dnsHostedZone = await DNSHostedZonesAPI.upsert({
    domain_name: domain,
    comment: comment,
    community_id: community_id,
    response: data
  })
  logger.child({ dnsHostedZone }).info('DNSHostedZonesAPI.upsert');

  // Create Records default if not exists
  if (data.HostedZone.ResourceRecordSetCount === 2) {
    await route53.create_default_records({ domain, hostedZoneId: data.HostedZone.Id });
  }

  return dnsHostedZone;
}

export default check_user(create_domain, Roles.ADMIN);