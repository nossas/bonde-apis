import { RecipientTicket } from "./"

export type VolunteerUser = {
  user_id: number
  disponibilidade_de_atendimentos: string
  atendimentos_em_andamento_calculado_: number
  email: string
  name: string
  organization_id: number
  latitude: string
  longitude: string
  whatsapp: string
  phone: string
  registration_number: string
  ticket_id?: number
};

export type CreateVolunteerTicket = {
  recipient_ticket: RecipientTicket
  volunteer_user: VolunteerUser
  agent: number
}
