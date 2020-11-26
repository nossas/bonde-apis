import { HasuraTicket } from "./ticket"
import { VolunteerUser } from "./volunteer"

export type UpdateRecipientTicket = {
  recipient_ticket: Pick<HasuraTicket, 'organization_id' | 'nome_msr' | 'ticket_id'> 
  volunteer_user: Pick<VolunteerUser, 'name' | 'ticket_id' | 'registration_number' | 'whatsapp' | 'phone'>
  agent: number
}