import fetch from './client';
import logger from '../logger';


export const queries = {
  update_recipient: `  
    mutation UpdateRecipient($update_fields: recipients_set_input, $id: Int!) {
      update_recipients(_set: $update_fields, where: { id: { _eq: $id } }) {
        returning {
          id
          pagarme_recipient_id,
          transfer_day: recipient(path: "transfer_day")
          transfer_interval: recipient(path: "transfer_interval")
          transfer_enabled: recipient(path: "transfer_enabled")
          bank_account: recipient(path: "bank_account")
        }
      }
    }
  `,
  create_recipient: `  
    mutation CreateRecipient($input: [recipients_insert_input!]!) {
      insert_recipients(objects: $input) {
        returning {
          id
          pagarme_recipient_id,
          transfer_day: recipient(path: "transfer_day")
          transfer_interval: recipient(path: "transfer_interval")
          transfer_enabled: recipient(path: "transfer_enabled")
          bank_account: recipient(path: "bank_account")
        }
      }
    }
  `,
  update_community: `
    mutation UpdateCommunity($update_fields: communities_set_input!, $id: Int!) {
      update_communities(_set: $update_fields, where: { id: { _eq: $id } }) {
        returning {
          id
          recipient_id
        }
      }
    }
  `
};

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const update = async (update_fields: any, id: number): Promise<any> => {   
  const { data }: any = await fetch({
    query: queries.update_recipient,
    variables: { id, update_fields }
  });

  return data.update_recipients.returning[0];
};

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const insert = async (input: any): Promise<any> => {
  const { data, ...props }: any = await fetch({
    query: queries.create_recipient,
    variables: { input }
  });

  
  logger.child({ props }).info('insert');
  const recipient = data.insert_recipients.returning[0];
  
  await fetch({
    query: queries.update_community,
    variables: { update_fields: { recipient_id: recipient.id }, id: input.community_id }
  });

  return recipient;
};
