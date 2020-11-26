export type Ticket = {
  id?: number
  status: string
  assignee_id?: number
  submitter_id?: number
  custom_fields: Array<{
    id: number
    value: string | null
  }>
  tags?: string[] | null
  updated_at?: string
  subject?: string
  requester_id?: number
  external_id?: number
  organization_id: number
  comment: {
    body: string
    author_id?: number
    public: false
  }
}

export type HasuraTicket = {
  link_match: string
  data_encaminhamento: string
  nome_voluntaria: string
  ticket_id: number
  status_acolhimento: string
  atrelado_ao_ticket: number | null
  nome_msr: string
} & Ticket