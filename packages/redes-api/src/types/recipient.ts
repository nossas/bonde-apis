import { HasuraTicket } from "./ticket"
import { VolunteerUser } from "./volunteer"

export type RecipientUser = {
  latitude: string
  longitude: string
  state: string
};

export interface RecipientTicket extends HasuraTicket {
  recipient: RecipientUser
}

export type UpdateRecipientTicket = {
  recipient_ticket: RecipientTicket
  volunteer_user: VolunteerUser
  agent: number
}