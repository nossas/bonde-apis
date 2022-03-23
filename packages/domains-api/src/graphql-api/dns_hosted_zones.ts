import { GraphQLClient } from 'graphql-request';
import logger from '../config/logger';
import { gql } from '../graphql-api/client';

// export const queries = {
const create_dns_hosted_zone = gql`  
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

      hosted_zone: response(path: "HostedZone")
      name_servers: response(path: "DelegationSet.NameServers")
      community_id
    }
  }
`;

const insert_dns_records = gql`
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
        dns_hosted_zone_id
      }
    }
  }
`;

const delete_dns_hosted_zone = gql`
  mutation ($id: Int!) {
    delete_dns_records(where: {
      dns_hosted_zone_id: { _eq: $id }
    }) {
      returning {
        id
        name
        record_type
      }
    }

    delete_dns_hosted_zones_by_pk(id: $id) {
      id
      domain_name
    }
  }
`;

const delete_dns_records = gql`
  mutation ($ids: [Int!]) {
    delete_dns_records(where: {
      id: { _in: $ids }
    }) {
      returning {
        id
        name
        record_type
      }
    }
  }
`;

const get_dns_hosted_zone = gql`
  query ($id: Int!) {
    dns_hosted_zones_by_pk(id: $id) {
      id
      comment
      domain_name
      ns_ok
      community_id

      hosted_zone_rest: response(path: "hosted_zone")
      hosted_zone: response(path: "HostedZone")
      name_servers_rest: response(path: "delegation_set.name_servers")
      name_servers: response(path: "DelegationSet.NameServers")

      dns_records {
        id
        name
        value
        record_type
        comment
        ttl
      }   
    }
  }
`;

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
  dns_records?: DNSRecordResult[]
  hosted_zone: any
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const upsert = async (input: DNSHostedZoneInput, client: any): Promise<DNSHostedZoneResult> => {
  const data: any = await client.request({
    document: create_dns_hosted_zone,
    variables: { input }
  });

  logger.child({ data }).info('dns_hosted_zones.upsert');

  return data.insert_dns_hosted_zones_one;
};

type DNSRecordInput = {
  dns_hosted_zone_id: number
  value: string | string[]
  name: string
  record_type: string
  ttl: number
  comment?: string
}

export type DNSRecordResult = {
  id: number
  dns_hosted_zone_id?: number
  value: string | string[]
  name: string
  record_type: 'A' | 'MX' | 'TXT' | 'CNAME' | 'AAA'
  ttl: number
  comment?: string
  created_at?: string
  updated_at?: string
}

export const records_upsert = async (objects: DNSRecordInput[], client: any): Promise<DNSRecordResult[]> => {
  const input = objects.map((o: any) => ({
    ...o,
    value: typeof o.value === "string" ? o.value : o.value.join(' ')
  }));

  logger.child({ input }).info('dns_hosted_zones.records_upsert');
  const data: any = await client.request({
    document: insert_dns_records,
    variables: { objects: input }
  });

  logger.child({ data }).info('dns_hosted_zones.records_upsert');

  return data.insert_dns_records.returning;
}

export const remove = async (id: number, client: any): Promise<void> => {
  const data: any = await client.request({
    document: delete_dns_hosted_zone,
    variables: { id }
  });

  logger.child({ data }).info('dns_hosted_zones.delete');
}

export const remove_records = async (ids: number[], client: any): Promise<void> => {
  const data: any = await client.request({
    document: delete_dns_records,
    variables: { ids }
  });

  logger.child({ data }).info('dns_hosted_zones.remove_records');
}

export const get = async (id: number, client: any): Promise<DNSHostedZoneResult> => {
  const data: any = await client.request({
    document: get_dns_hosted_zone,
    variables: { id }
  });

  logger.child({ data }).info('dns_hosted_zones.get');

  const dnsHostedZone = data.dns_hosted_zones_by_pk;
  return {
    ...dnsHostedZone,
    hosted_zone: dnsHostedZone.hosted_zone || dnsHostedZone.hosted_zone_rest,
    name_servers: dnsHostedZone.name_servers || dnsHostedZone.name_servers_rest
  };
}

// Find

const find_dns_hosted_zone = gql`
  query ($domain: String!) {
    dns_hosted_zones(where: { domain_name: { _eq: $domain } }) {
      id
      comment
      domain_name
      ns_ok
      community_id

      hosted_zone_rest: response(path: "hosted_zone")
      hosted_zone: response(path: "HostedZone")
      name_servers_rest: response(path: "delegation_set.name_servers")
      name_servers: response(path: "DelegationSet.NameServers")

      dns_records {
        id
        name
        value
        record_type
        comment
        ttl
      }
    }
  }
`;

interface DNSHostedZoneFindParams {
  domain: string;
}

export const find = async ({
  domain
}: DNSHostedZoneFindParams, client: GraphQLClient): Promise<DNSHostedZoneResult[]> => {
  const data = await client.request<{ dns_hosted_zones: any[] }, DNSHostedZoneFindParams>({
    document: find_dns_hosted_zone,
    variables: { domain }
  });

  logger.child({ domain }).info('dns_hosted_zones.find');

  return data.dns_hosted_zones.map((dnsHostedZone) => ({
    ...dnsHostedZone,
    hosted_zone: dnsHostedZone.hosted_zone || dnsHostedZone.hosted_zone_rest,
    name_servers: dnsHostedZone.name_servers || dnsHostedZone.name_servers_rest
  }));
}