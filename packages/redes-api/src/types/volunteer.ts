import { HasuraTicket } from "./"

export type VolunteerUser = {
  user_id: number
  disponibilidade_de_atendimentos: string
  atendimentos_em_andamento_calculado_: number
  email: string
  name: string
  organization_id: number
  latitude: string
  longitude: string
  whatsapp?: string
  phone?: string
  registration_number: string
  ticket_id?: number
};

export type CreateVolunteerTicket = {
  recipient_ticket: Pick<HasuraTicket, 'external_id' | 'nome_msr' | 'ticket_id'>
  volunteer_user: Pick<VolunteerUser, 'user_id' | 'organization_id' | 'name'>
  agent: number
  community_id: number
}
