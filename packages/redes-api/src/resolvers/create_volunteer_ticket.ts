import * as yup from "yup";
import logger from '../logger';
import * as zendesk from "node-zendesk";
import * as tickets from '../graphql-api/tickets';
import { CreateVolunteerTicket } from "../types"
import { check_user, Roles, Context } from '../permissions';
import config from '../config';
import { volunteerTicket, composeCustomFields } from "../utils";

if (!config.zendeskApiToken) throw new Error('ZENDESK_API_TOKEN not found');
if (!config.zendeskApiUrl) throw new Error('ZENDESK_API_URL not found');
if (!config.zendeskApiUser) throw new Error('ZENDESK_API_USER not found');

type Args = {
  input: CreateVolunteerTicket
}

const hasuraSchema = yup
  .object()
  .shape({
    assignee_id: yup.number().required(),
    requester_id: yup.number().required(),
    submitter_id: yup.number().required(),
    status: yup.string().required(),
    subject: yup.string().required(),
    description: yup.string().required(),
    external_id: yup.number().required(),
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
    community_id: yup.number().required(),
    ticket_id: yup.number().required(),
    created_at: yup.string().required(),
    organization_id: yup.number().required(),
    tags: yup.array().of(yup.string()),
    updated_at: yup.string().required(),
    link_match: yup.string().required(),
    data_encaminhamento: yup.string().required(),
    nome_msr: yup.string().required(),
    status_acolhimento: yup.string().required()
  })
  .required();


const create_volunteer_ticket = async (_: void, args: Args, _context: Context): Promise<any> => {
  const client = zendesk.createClient({
    username: process.env.ZENDESK_API_USER,
    token: process.env.ZENDESK_API_TOKEN,
    remoteUri: process.env.ZENDESK_API_URL
  });

  const ticket = volunteerTicket(args.input)

  try {
    const zendeskTicket = await client.tickets.create({ ticket });

    const hasuraTicket = {
      ...zendeskTicket,
      ...composeCustomFields(zendeskTicket.custom_fields),
      ticket_id: zendeskTicket.id,
      community_id: args.input.community_id
    };

    const validatedHasuraTicket = await hasuraSchema.validate(hasuraTicket, {
      stripUnknown: true
    });

    const res = await tickets.create([validatedHasuraTicket])

    return res[0]
  } catch(e) {
    logger.child({ e }).error('create_volunteer_ticket')
    return e
  }
}

export default check_user(create_volunteer_ticket, Roles.USER)