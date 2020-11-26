import config from "./config"
import { CreateVolunteerTicket, Ticket, UpdateRecipientTicket } from "./types"

if (!config.zendeskOrganizations) throw new Error('ZENDESK_ORGANIZATIONS not found');

export const zendeskOrganizations = JSON.parse(
  process.env.ZENDESK_ORGANIZATIONS || "{}"
);

export const getAgentZendeskUserId = (
  id?: number | null
): number => {
  switch (id) {
    case 281: //"Larissa"
      return 377510044432;
    case 346: //"Ana",
      return 377577169651;
    case 339: //"Gabriela",
      return 377511446392;
    default:
      // "Voluntária"
      return 373018450472;
  }
};

export const getVolunteerType = (id: number): { type: string; registry_type: string } => {
  if (Number(id) === Number(zendeskOrganizations["lawyer"]))
    return {
      type: "Advogada",
      registry_type: "OAB"
    };
  if (Number(id) === Number(zendeskOrganizations["therapist"]))
    return {
      type: "Psicóloga",
      registry_type: "CRP"
    };
  throw new Error(`Volunteer organization_id '${id}' not supported in search for type`);
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

const recipientComment = ({ volunteer_user, assignee_name, recipient_name }) => {
  const {
    registration_number,
    organization_id,
    name,
    whatsapp,
    phone
  } = volunteer_user;
  const { type, registry_type } = getVolunteerType(organization_id);

  return `Olá, ${recipient_name}!

Boa notícia!

Conseguimos localizar uma ${type.toLowerCase()} disponível próxima a você. Estamos te enviando os dados abaixo para que entre em contato em até 30 dias. É muito importante atentar-se a esse prazo pois, após esse período, a sua vaga pode expirar. Não se preocupe, caso você não consiga, poderá retornar à fila de atendimento se cadastrando novamente pelo site.

${type}: ${name.split(" ")[0]}

Telefone: ${phone || whatsapp}

${registry_type}: ${registration_number}

Diante do contexto da pandemia do covid-19, sabemos que podem surgir algumas dificuldades para que receba o acolhimento necessário, especialmente à distância, que é a recomendação neste momento. Por isso, caso haja algum obstáculo que impossibilite que o seu atendimento aconteça de forma segura, por favor nos escreva e para te oferecermos mais informações sobre como buscar ajuda na rede pública de atendimento. Não se preocupe, você também poderá iniciar os atendimentos de modo presencial quando esse período tão difícil passar.

Todos os atendimentos do Mapa devem ser gratuitos pelo tempo que durarem. Caso você seja cobrada, comunique imediatamente a nossa equipe. No momento de contato com a voluntária, por favor, identifique que você buscou ajuda via Mapa do Acolhimento.

Agradecemos pela coragem, pela confiança e esperamos que seja bem acolhida! Pedimos que entre em contato para compartilhar a sua experiência de atendimento.

Um abraço,

${assignee_name} do Mapa do Acolhimento`;
};

export const agentDicio = {
  377510044432: "Larissa",
  377577169651: "Ana",
  377511446392: "Gabriela",
};

export const recipientTicket = ({ recipient_ticket, volunteer_user, agent }: UpdateRecipientTicket): Ticket & { ticket_id: number } => ({
  ticket_id: recipient_ticket.ticket_id,
  assignee_id: getAgentZendeskUserId(agent),
  status: "pending",
  organization_id: recipient_ticket.organization_id,
  comment: {
    body: recipientComment({
      volunteer_user,
      recipient_name: recipient_ticket.nome_msr,
      assignee_name: agentDicio[getAgentZendeskUserId(agent)] || "Voluntária"
    }),
    author_id: getAgentZendeskUserId(agent),
    public: true
  },
  custom_fields: [
    {
      id: 360016631592,
      value: volunteer_user.name
    },
    {
      id: 360014379412,
      value: "encaminhamento__realizado"
    },
    {
      id: 360016631632,
      value: `https://mapadoacolhimento.zendesk.com/agent/tickets/${volunteer_user.ticket_id}`
    },
    {
      id: 360017432652,
      value: String(getCurrentDate())
    }
  ],
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