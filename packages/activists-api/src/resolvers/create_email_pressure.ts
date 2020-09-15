import { IActionData, IBaseAction } from '../types';
import * as NotificationsAPI from '../graphql-api/notifications';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';

type PressureAction = {
  targets_id?: string
}

/**
 * Make a pressure to email using Notifications and Actions API
 * 
 * @param widget
 * @param activist 
 */
export const create_email_pressure = async ({ widget, activist, action }: IBaseAction<PressureAction>): Promise<IActionData> => {
  const { targets: settingsTargets, pressure_subject, pressure_body, } = widget.settings;
  const { targets_id } = action as PressureAction;

  let targets = '';
  try {
    const group = JSON.parse(settingsTargets).filter((g: any) => g.value === targets_id)[0];
    if (!!group) {
      targets = group.targets
    }
  } catch (e) {
    targets = settingsTargets
  }

  const mailInput = targets.split(';').map((target: string) => ({
    context: { activist, widget },
    body: pressure_body,
    subject: pressure_subject,
    email_from: `${activist.name} <${activist.email}>`,
    email_to: target
  }));

  await NotificationsAPI.send(mailInput);

  const { id, created_at } = await ActionsAPI.pressure({
    activist_id: activist.id,
    widget_id: widget.id,
    mobilization_id: widget.block.mobilization.id,
    cached_community_id: widget.block.mobilization.community.id,
    targets: targets
  });

  return {
    data: { activist_pressure_id: id },
    syncronize: async () => await ActionsAPI.pressure_sync_done({ id, sync_at: created_at })
  };
};

// Return a base action to resolvers pattern
export default makeActionResolver(create_email_pressure);
