import { IActionData, IBaseAction } from '../types';
import * as NotificationsAPI from '../graphql-api/notifications';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';

/**
 * Make a pressure to email using Notifications and Actions API
 * 
 * @param widget
 * @param activist 
 */
export const create_email_pressure = async ({ widget, activist }: IBaseAction<any>): Promise<IActionData> => {
  const { targets, pressure_subject, pressure_body, } = widget.settings;

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
    cached_community_id: widget.block.mobilization.community.id
  });

  return {
    data: { activist_pressure_id: id },
    syncronize: async () => await ActionsAPI.pressure_sync_done({ id, sync_at: created_at })
  };
};

// Return a base action to resolvers pattern
export default makeActionResolver(create_email_pressure);