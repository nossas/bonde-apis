export type MatchTicket = {
  individuals_ticket_id: number
  volunteers_ticket_id: number
  individuals_user_id: number
  volunteers_user_id: number
  community_id: number
  status: string
}

export type CreateMatch = {
  recipient: {
    external_id: number
    nome_msr: string
    ticket_id: number
    organization_id: number
    requester_id: number
  }
  volunteer: {
    user_id: number
    organization_id: number
    name: string
    ticket_id?: number
    registration_number: string
    whatsapp?: string
    phone?: string
  }
  agent: number
  community_id: number
}