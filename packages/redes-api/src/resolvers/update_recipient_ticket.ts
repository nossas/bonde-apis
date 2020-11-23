import * as yup from "yup";
import * as zendesk from "node-zendesk";

import * as tickets from '../graphql-api/tickets';
import { check_user, Roles } from '../permissions';

import config from '../config';
import { recipientTicket, composeCustomFields } from "../utils";
import { UpdateRecipientTicket } from "../types"
import logger from '../logger';

if (!config.zendeskApiToken) throw new Error('ZENDESK_API_TOKEN not found');
if (!config.zendeskApiUrl) throw new Error('ZENDESK_API_URL not found');
if (!config.zendeskApiUser) throw new Error('ZENDESK_API_USER not found');

type Args = {
  input: UpdateRecipientTicket
}

const hasuraSchema = yup
  .object()
  .shape({
    status: yup.string().required(),
    assignee_id: yup.number().required(),
    custom_fields: yup
      .array()
      .of(
        yup
          .object()
          .shape({
            id: yup.number(),
            value: yup.string().nullable()
          })
          .required()
      )
      .min(4)
      .required(),
    tags: yup.array().of(yup.string()),
    updated_at: yup.string().required(),
    link_match: yup.string().required(),
    data_encaminhamento: yup.string().required(),
    nome_voluntaria: yup.string().required(),
    status_acolhimento: yup.string().required(),
    ticket_id: yup.number().required()
  })
  .required();


const update_recipient_ticket = async (_: void, args: Args): Promise<any> => {
  const client = zendesk.createClient({
    username: process.env.ZENDESK_API_USER,
    token: process.env.ZENDESK_API_TOKEN,
    remoteUri: process.env.ZENDESK_API_URL
  });

  const ticket = recipientTicket(args.input)

  try {
    const zendeskTicket = await client.tickets.update(ticket.ticket_id, {   
      ticket 
    });

    const hasuraTicket = {
      ...zendeskTicket,
      ...composeCustomFields(zendeskTicket.custom_fields),
      ticket_id: zendeskTicket.id,
    };

    const validatedHasuraTicket = await hasuraSchema.validate(hasuraTicket, {
      stripUnknown: true
    });

    const res = await tickets.update(validatedHasuraTicket, [validatedHasuraTicket.ticket_id])

    return res[0]
  } catch(e) {
    logger.error(e)
    return e
  }
}

export default check_user(update_recipient_ticket, Roles.USER)