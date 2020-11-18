import logger from '../logger';
import * as zendesk from "node-zendesk";
import * as tickets from '../graphql-api/tickets';
import { CreateVolunteerTicket } from "../types"
import { check_user, Roles } from '../permissions';
import config from '../config';
import { volunteerTicket } from "../utils";

if (!config.zendeskApiToken) throw new Error('ZENDESK_API_TOKEN not found');
if (!config.zendeskApiUrl) throw new Error('ZENDESK_API_URL not found');
if (!config.zendeskApiUser) throw new Error('ZENDESK_API_USER not found');

type Args = {
  input: CreateVolunteerTicket
}

const create_volunteer_ticket = async (_: void, args: Args): Promise<{ ticket_id: number }[] | undefined> => {
  const client = zendesk.createClient({
    username: process.env.ZENDESK_API_USER,
    token: process.env.ZENDESK_API_TOKEN,
    remoteUri: process.env.ZENDESK_API_URL
  });

  const ticket = volunteerTicket(args.input)

  try {
    const zendeskTicket = await client.tickets.create({ ticket });
    const hasuraTicket = await tickets.create([zendeskTicket])

    return hasuraTicket
  } catch(e) {
    logger.error(e)
    return undefined
  }
}

export default check_user(create_volunteer_ticket, Roles.USER);