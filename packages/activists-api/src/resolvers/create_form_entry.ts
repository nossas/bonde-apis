import logger from '../logger';
import { IActionData, IBaseAction, FormEntryInput } from '../types';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';

export const create_form_entry = async ({ action, activist, widget }: IBaseAction<FormEntryInput>): Promise<IActionData> => {
  const { id, created_at } = await ActionsAPI.send_form({
    activist_id: activist.id,
    widget_id: widget.id,
    cached_community_id: widget.block.mobilization.community.id,
    fields: JSON.stringify(action?.fields || []),
  });

  logger.child({ id, created_at }).info('send_form');

  return {
    data: { form_entry_id: id },
    syncronize: async () => await ActionsAPI.send_form_sync_done({ id, sync_at: created_at })
  };
};

export default makeActionResolver<FormEntryInput>(create_form_entry);