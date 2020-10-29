import fetch from './client';
import logger from '../logger';


export const queries = {
  create_dns_hosted_zone: `  
    mutation ($input: dns_hosted_zones_insert_input!) {
      insert_dns_hosted_zones_one(
        object: $input,
        on_conflict: {
          constraint: dns_hosted_zones_domain_name_key,
          update_columns: [response]
        }
      ) {
        id
        domain_name
        ns_ok
        comment
        created_at
        updated_at
        name_servers: response(path: "DelegationSet.NameServers")
        community_id
      }
    }
  `,
  insert_dns_records: `
    mutation ($objects: [dns_records_insert_input!]!) {
      insert_dns_records(
        objects: $objects,
        on_conflict: {
          constraint: dns_records_name_record_type_key,
          update_columns: [value, ttl, comment]
        }
      ) {
        returning {
          id
          name
          value
          record_type
          comment
          ttl
          created_at
          updated_at
        }
      }
    }
  `
};

type DNSHostedZoneInput = {
  domain_name: string
  comment?: string
  community_id: number
  response: any
}

export type DNSHostedZoneResult = {
  id: number
  domain_name: string
  comment: string
  name_servers: string[]
  ns_ok: boolean
  created_at: string
  updated_at: string
  community_id: number
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const upsert = async (input: DNSHostedZoneInput): Promise<DNSHostedZoneResult> => {
  const { data, errors }: any = await fetch({
    query: queries.create_dns_hosted_zone,
    variables: { input }
  });

  logger.child({ errors, data }).info('dns_hosted_zones.insert');

  return data.insert_dns_hosted_zones_one;
};

type DNSRecordInput = {
  dns_hosted_zone_id: number
  value: string
  name: string
  record_type: string
  ttl: number
  comment?: string
}

export type DNSRecordResult = {
  id: number
  dns_hosted_zone_id: number
  value: string
  name: string
  record_type: string
  ttl: number
  comment?: string
  created_at: string
  updated_at: string
}

export const records_upsert = async (objects: DNSRecordInput[]): Promise<DNSRecordResult[]> => {
  const { data, errors }: any = await fetch({
    query: queries.insert_dns_records,
    variables: { objects }
  });

  logger.child({ errors, data }).info('dns_hosted_zones.insert');

  return data.insert_dns_records.returning;
}