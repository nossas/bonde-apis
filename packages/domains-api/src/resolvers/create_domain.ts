// import * as recipients from '../graphql-api/recipients';
import { check_user, Roles } from '../permissions';
import config from '../config';

if (!config.awsAccessKey) throw new Error('AWS_ACCESS_KEY not found');
if (!config.awsSecretKey) throw new Error('AWS_SECRET_KEY not found');

type DomainInput = {
  domain: string
  community_id: number
}

type Args = {
  input: DomainInput
}

const create_domain = async (_: void, args: Args): Promise<DomainInput | undefined> => {
  const { input: { domain, community_id } } = args;
  // const client: any = await pagarme.client.connect({ api_key: config.pagarmeApiKey });

  
  // if (!!id) {
  //   // The next line ensures only 1 recipient by Community on Pagarme
  //   if (!recipient.id) throw new Error('recipient.id is required');

  //   const pagarmeUpdated: Recipient = await client.recipients.update(recipient);

  //   await recipients.update({
  //     recipient: pagarmeUpdated,
  //     pagarme_recipient_id: pagarmeUpdated.id,
  //     transfer_day: pagarmeUpdated.transfer_day,
  //     transfer_enabled: pagarmeUpdated.transfer_enabled
  //   }, id);

  //   return { id, recipient: pagarmeUpdated, community_id };
  // }

  // // Insert Recipient on Pagarme
  // const pagarmeCreated: Recipient = await client.recipients.create(recipient);
  // // Insert Recipient on Bonde database (API GraphQL)
  // const bondeCreated = await recipients.insert({
  //   recipient: pagarmeCreated,
  //   pagarme_recipient_id: pagarmeCreated.id,
  //   transfer_day: pagarmeCreated.transfer_day,
  //   transfer_enabled: pagarmeCreated.transfer_enabled,
  //   community_id
  // });
  
  return { domain, community_id };
}

export default check_user(create_domain, Roles.ADMIN);