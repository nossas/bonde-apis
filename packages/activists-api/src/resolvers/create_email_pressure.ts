import logger from '../logger';
import { IActionData, IBaseAction, GroupTarget } from '../types';
import * as NotificationsAPI from '../graphql-api/notifications';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';

type PressureAction = {
  targets_id?: string
  email_subject?: string
  email_body?: string
}

/**
 * Make a pressure to email using Notifications and Actions API
 * 
 * @param widget
 * @param activist 
 */
export const create_email_pressure = async ({ widget, activist, action }: IBaseAction<PressureAction>): Promise<IActionData> => {
  logger.info('create_email_pressure')
  const { settings: { targets: settingsTargets, pressure_subject, pressure_body }, pressure_targets } = widget;
  const { targets_id, email_subject, email_body } = action || {};

  let targets: string[] = [];
  if (pressure_targets && pressure_targets.length > 0) {
    const group = pressure_targets.filter((g: GroupTarget) => g.identify === targets_id)[0];
    if (!!group) {
      targets = group.targets;
    }
    logger.child({ targets }).info('pressure_targets is true');
  } else {
    targets = settingsTargets.split(';');
  }

  const mailInput = targets.map((target: string) => ({
    context: { activist, widget },
    body: email_body || pressure_body,
    subject: email_subject || pressure_subject,
    email_from: `${activist.name} <${activist.email}>`,
    email_to: target
  }));

  try {
    await NotificationsAPI.send(mailInput);
  } catch (e) {
    logger.error(e);
  }

  logger.child({ mailInput }).info('NotificationsAPI');

  const { id, created_at } = await ActionsAPI.pressure({
    activist_id: activist.id,
    widget_id: widget.id,
    mobilization_id: widget.block.mobilization.id,
    cached_community_id: widget.block.mobilization.community.id,
    targets: targets.join(';')
  });

  return {
    data: { activist_pressure_id: id },
    syncronize: async () => await ActionsAPI.pressure_sync_done({ id, sync_at: created_at })
  };
};

// Return a base action to resolvers pattern
export default makeActionResolver(create_email_pressure);
