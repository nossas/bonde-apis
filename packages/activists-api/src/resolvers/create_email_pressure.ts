import jwt from "jsonwebtoken";
import logger from '../logger';
import { IActionData, IBaseAction, GroupTarget, Activist } from '../types';
import * as NotificationsAPI from '../graphql-api/notifications';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';

export type PressureAction = {
  targets_id?: string
  email_subject?: string
  email_body?: string
  token: string
}

type PressureEmailArgs = {
  activist: Activist
  emailBody: string
  emailSubject: string
  targets: any[]
  context?: any
}

const send_pressure_mail = async ({
  activist,
  emailBody,
  emailSubject,
  targets,
  context = {}
}: PressureEmailArgs) => {
  // Subject and Body orders
  // 1 Changed by activists
  // 2 Configured in group of targets
  // 3 Configured in settings of widget
  const mailInput = targets.map((target: string) => ({
    context: { activist, ...context },
    body: emailBody,
    subject: emailSubject, // email_subject || group?.email_subject || pressure_subject,
    email_from: `${activist.name} <${activist.email}>`,
    email_to: target
  }));

  // Envia e-mail de pressão
  await NotificationsAPI.send(mailInput);
  logger.child({ mailInput }).info('NotificationsAPI');
}

/**
 * Make a pressure to email using Notifications and Actions API
 * 
 * @param widget
 * @param activist
 */
export const create_email_pressure = async ({ widget, activist, action }: IBaseAction<PressureAction>): Promise<IActionData> => {
  const {
    settings: {
      targets: settingsTargets,
      pressure_subject: pressureSubject,
      pressure_body: pressureBody,
      batch_limit = 100,
      mail_limit = 1000,
      optimization_enabled = true
    },
    pressure_targets: pressureTargets
  } = widget;
  const {
    targets_id: targetsId,
    email_subject: emailSubject,
    email_body: emailBody,
    token
  } = action || {};

  // Validate pressure token
  if (!token || !process.env.ACTION_SECRET_KEY) throw new Error("invalid_action_token");

  try {
    jwt.verify(token, process.env.ACTION_SECRET_KEY);
  } catch (e) {
    logger.error("Invalid token", e);
    throw new Error("invalid_action_token");
  }

  let targets: string[] = [];
  let group: GroupTarget | null = null;
  if (pressureTargets && pressureTargets.length > 0) {
    group = pressureTargets.filter((g: GroupTarget) => g.identify === targetsId)[0];
    if (!!group) {
      targets = group.targets;
    }
  } else {
    if (typeof settingsTargets === 'string') {
      targets = settingsTargets.split(';');
    } else {
      targets = settingsTargets
    }
  }

  const activistPressure = {
    activist_id: activist.id,
    widget_id: widget.id,
    mobilization_id: widget.block.mobilization.id,
    cached_community_id: widget.block.mobilization.community.id,
    targets: {
      group: group?.identify,
      targets: targets
    }
  }

  console.log("optimization_enabled", { optimization_enabled });
  if (optimization_enabled) {
    // Pressão otimizado foi habilitada
    const pressureInfo = await ActionsAPI.get_pressure_info(widget.id);
    console.log("pressureInfo", pressureInfo);
    // Como dividir o lote de e-mails a partir da mudança de limite do lote??
    // Status
    // draft: envios antigos ou valor de criação padrão
    // sent: enviado fora do processo de otimização
    // sent_optimized: enviado como gatilho do processo de otimização
    // awaiting_optimized: não enviado e aguardando envio do lote
    // batch_optimized: enviado como parte do processo de otimização
  
    if (pressureInfo.mail_count >= mail_limit) {
      // Esta dentro do limite único, inicia o processo de otimização
      if ((pressureInfo.batch_count + 1) >= batch_limit) {
        // Cria nova pressão e atualiza pressões otimizadas
        const { pressure: { id, created_at }, batch_activists } = await ActionsAPI
          .pressure_optimized({ ...activistPressure, status: "sent_optimized" }, widget.id);

        const count = batch_activists.length + 1;
        let activists = batch_activists.map((a) => a.email);
        activists.push(activist.email);
        activists = activists.filter((item, index) => activists.indexOf(item) === index);
 
        // Limite de lote atingido, enviar e-mail e atualizar pressões
        // Enviar e-mail de pressão customizado
        const contentBody = group?.email_body || pressureBody;
        const optimziedBody = `
          Você recebeu {{ count }} pressões com a seguinte demanda:

          ${contentBody}
          _________________
          Assinado,
          {% for email in activists %}{{ email }}
          {% endfor %}
        `;

        await send_pressure_mail({
          context: { count, activists },
          activist,
          targets,
          emailBody: optimziedBody,
          emailSubject: group?.email_subject || pressureSubject
        });

        logger.child({ id, created_at }).info('ActionsAPI');
        return {
          data: { activist_pressure_id: id },
          syncronize: async () => await ActionsAPI.pressure_sync_done({
            id,
            sync_at: created_at
          })
        };
      }
      // Cria uma nova pressão aguardando o próximo lote de envio
      const { id, created_at } = await ActionsAPI.pressure({
        ...activistPressure,
        status: "awaiting_optimized"
      });

      logger.child({ id, created_at }).info('ActionsAPI');
      return {
        data: { activist_pressure_id: id },
        syncronize: async () => await ActionsAPI.pressure_sync_done({
          id,
          sync_at: created_at
        })
      };
    }
  }

  // Envio de e-mail para pressão não otimizada
  await send_pressure_mail({
    activist,
    targets,
    emailBody: emailBody || group?.email_body || pressureBody,
    emailSubject: emailSubject || group?.email_subject || pressureSubject
  });
  // Cria a pressão na base de dados
  const { id, created_at } = await ActionsAPI.pressure({
    ...activistPressure,
    status: "sent"
  });

  logger.child({ id, created_at }).info('ActionsAPI');
  return {
    data: { activist_pressure_id: id },
    syncronize: async () => await ActionsAPI.pressure_sync_done({ id, sync_at: created_at })
  };
};

// Return a base action to resolvers pattern
export default makeActionResolver(create_email_pressure);
