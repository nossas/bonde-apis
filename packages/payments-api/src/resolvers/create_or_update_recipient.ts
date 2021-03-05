import pagarme from 'pagarme';
import * as recipients from '../graphql-api/recipients';
import { check_user, Roles } from '../permissions';
import config from '../config';

if (!config.pagarmeApiKey) throw new Error('PAGARME_API_KEY not found');

type BankAccount = {
  object?: string
  id?: number
  bank_code: string
  agencia: string
  agencia_dv?: string
  conta: string
  conta_dv: string
  type: string
  document_type: string
  document_number: string
  legal_name: string

}

type Recipient = {
  object?: string
  id?: string
  transfer_enabled: boolean
  transfer_interval: string
  transfer_day: number
  bank_account: BankAccount
}

type RecipientEntity = {
  id?: number
  recipient: Recipient
  community_id: number
}

type Args = {
  input: RecipientEntity
}

const create_or_update = async (_: void, args: Args): Promise<RecipientEntity | undefined> => {
  const { input: { id, recipient, community_id } } = args;
  const client: any = await pagarme.client.connect({ api_key: config.pagarmeApiKey });

  recipient.bank_account.legal_name = recipient.bank_account.legal_name.substring(0,29);

  if (!!id) {
    // The next line ensures only 1 recipient by Community on Pagarme
    if (!recipient.id) throw new Error('recipient.id is required');

    const pagarmeUpdated: Recipient = await client.recipients.update(recipient);

    await recipients.update({
      recipient: pagarmeUpdated,
      pagarme_recipient_id: pagarmeUpdated.id,
      transfer_day: pagarmeUpdated.transfer_day,
      transfer_enabled: pagarmeUpdated.transfer_enabled
    }, id);

    return { id, recipient: pagarmeUpdated, community_id };
  }

  // Insert Recipient on Pagarme
  const pagarmeCreated: Recipient = await client.recipients.create(recipient);
  // Insert Recipient on Bonde database (API GraphQL)
  const bondeCreated = await recipients.insert({
    recipient: pagarmeCreated,
    pagarme_recipient_id: pagarmeCreated.id,
    transfer_day: pagarmeCreated.transfer_day,
    transfer_enabled: pagarmeCreated.transfer_enabled,
    community_id
  });

  return { id: bondeCreated.id, recipient: pagarmeCreated, community_id };
}

export default check_user(create_or_update, Roles.ADMIN);