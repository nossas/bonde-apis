import fetch from './client';
import logger from '../logger';


export const queries = {
  // update_recipient: `  
  //   mutation UpdateRecipient($update_fields: recipients_set_input, $id: Int!) {
  //     update_recipients(_set: $update_fields, where: { id: { _eq: $id } }) {
  //       returning {
  //         id
  //         pagarme_recipient_id,
  //         transfer_day: recipient(path: "transfer_day")
  //         transfer_interval: recipient(path: "transfer_interval")
  //         transfer_enabled: recipient(path: "transfer_enabled")
  //         bank_account: recipient(path: "bank_account")
  //       }
  //     }
  //   }
  // `,
  create_dns_hosted_zone: `  
    mutation CreateRecipient($input: dns_hosted_zones_insert_input!) {
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
  // update_community: `
  //   mutation UpdateCommunity($update_fields: communities_set_input!, $id: Int!) {
  //     update_communities(_set: $update_fields, where: { id: { _eq: $id } }) {
  //       returning {
  //         id
  //         recipient_id
  //       }
  //     }
  //   }
  // `
};

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
// export const update = async (update_fields: any, id: number): Promise<any> => {   
//   const { data }: any = await fetch({
//     query: queries.update_recipient,
//     variables: { id, update_fields }
//   });

//   return data.update_recipients.returning[0];
// };

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
