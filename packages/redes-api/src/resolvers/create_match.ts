import logger from '../logger';
import * as match from '../graphql-api/match';
import create_volunteer_ticket from "./create_volunteer_ticket"
import update_recipient_ticket  from "./update_recipient_ticket"
import { CreateMatch, MatchTicket } from "../types"
import { check_user, Roles, Context } from '../permissions';
import config from '../config';

if (!config.zendeskApiToken) throw new Error('ZENDESK_API_TOKEN not found');
if (!config.zendeskApiUrl) throw new Error('ZENDESK_API_URL not found');
if (!config.zendeskApiUser) throw new Error('ZENDESK_API_USER not found');

type Args = {
  input: CreateMatch
}

const create_match = async (_: void, args: Args, context: Context): Promise<any> => {
  const { input: { recipient, volunteer, agent, community_id } } = args
  try {
    const volunteerRes = await create_volunteer_ticket(undefined, {
      input: {
        recipient_ticket: {
          external_id: recipient.external_id,
          nome_msr: recipient.nome_msr,
          ticket_id: recipient.ticket_id,
        },
        volunteer_user: {
          user_id: volunteer.user_id,
          organization_id: volunteer.organization_id,
          name: volunteer.name,
        },
        agent,
        community_id
      }
    }, context)

    await update_recipient_ticket(undefined, {
      input: {
        recipient_ticket: {
          nome_msr: recipient.nome_msr,
          ticket_id: recipient.ticket_id,
          organization_id: recipient.organization_id
        },
        volunteer_user: {
          name: volunteer.name,
          ticket_id: volunteerRes.ticket_id,
          registration_number: volunteer.registration_number,
          organization_id: volunteer.organization_id,
          whatsapp: volunteer.whatsapp,
          phone: volunteer.phone
        },
        agent,
        community_id
      }
    }, context)

    const matchTicket: MatchTicket = {
      individuals_ticket_id: recipient.ticket_id,
      volunteers_ticket_id: volunteerRes.ticket_id,
      individuals_user_id: recipient.requester_id,
      volunteers_user_id: volunteer.user_id,
      community_id,
      status: "encaminhamento__realizado"
    }

    return await match.create(matchTicket)
  } catch(e) {
    logger.error(e)
    return undefined
  }
}

export default check_user(create_match, Roles.USER)