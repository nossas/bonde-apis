import config from "./config"
import { CreateVolunteerTicket, Ticket } from "./types"

if (!config.zendeskOrganizations) throw new Error('ZENDESK_ORGANIZATIONS not found');

export const zendeskOrganizations = JSON.parse(
  process.env.ZENDESK_ORGANIZATIONS || "{}"
);

export const getAgentZendeskUserId = (
  id?: number | null
): number | undefined => {
  switch (id) {
    case 281: //"Larissa"
      return 377510044432;
    case 346: //"Ana",
      return 377577169651;
    case 339: //"Gabriela",
      return 377511446392;
    case null:
    case undefined:
      return undefined;
    default:
      // "Voluntária"
      return 373018450472;
  }
};

export const getVolunteerType = (id: number): { type: string; registry_type: string } => {
  if (Number(id) === zendeskOrganizations["lawyer"])
    return {
      type: "Advogada",
      registry_type: "OAB"
    };
  if (Number(id) === zendeskOrganizations["therapist"])
    return {
      type: "Psicóloga",
      registry_type: "CRP"
    };
  throw new Error("Volunteer organization_id not supported in search for type");
};

export const getCurrentDate = (): string => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, "0");
  const mm = String(today.getMonth() + 1).padStart(2, "0");
  const yyyy = today.getFullYear();

  return `${yyyy}-${mm}-${dd}`;
};

export const volunteerTicket = ({ recipient_ticket, volunteer_user, agent }: CreateVolunteerTicket): Ticket => ({
  external_id: recipient_ticket.external_id,
  requester_id: volunteer_user.user_id,
  submitter_id: getAgentZendeskUserId(agent),
  assignee_id: getAgentZendeskUserId(agent),
  status: "pending",
  subject: `[${getVolunteerType(volunteer_user.organization_id).type}] ${
    volunteer_user.name
  }`,
  organization_id: volunteer_user.organization_id,
  comment: {
    body: `Voluntária recebeu um pedido de acolhimento de ${recipient_ticket.nome_msr}`,
    author_id: getAgentZendeskUserId(agent),
    public: false
  },
  custom_fields: [
    {
      id: 360016681971,
      value: recipient_ticket.nome_msr
    },
    {
      id: 360016631632,
      value: `https://mapadoacolhimento.zendesk.com/agent/tickets/${recipient_ticket.ticket_id}`
    },
    {
      id: 360014379412,
      value: "encaminhamento__realizado"
    },
    {
      id: 360017432652,
      value: String(getCurrentDate())
    }
  ]
})

export const customFieldsDicio: Record<number, string> = {
  360014379412: "status_acolhimento",
  360016631592: "nome_voluntaria",
  360016631632: "link_match",
  360016681971: "nome_msr",
  360017056851: "data_inscricao_bonde",
  360017432652: "data_encaminhamento",
  360021665652: "status_inscricao",
  360021812712: "telefone",
  360021879791: "estado",
  360021879811: "cidade",
  360032229831: "atrelado_ao_ticket"
};

export const composeCustomFields = (custom_fields: Array<{ id: number; value: any }>): Record<string, any> =>
  custom_fields.reduce((newObj, old) => {
    const key = customFieldsDicio[old.id] && customFieldsDicio[old.id];
    return {
      ...newObj,
      [key]: old.value
    };
  }, {});