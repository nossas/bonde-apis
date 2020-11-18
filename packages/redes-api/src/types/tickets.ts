export interface Ticket {
  id: number
  status: string
  assignee_id: number
  custom_fields: Array<{
    id: number
    value: string | null
  }>
  tags: string[]
  updated_at: string
}

export interface HasuraTicket extends Ticket {
  link_match: string
  data_encaminhamento: string
  nome_voluntaria: string
  status_acolhimento: string
  ticket_id: number
}
