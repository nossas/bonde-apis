import logger from '../logger';
import { IActionData, IBaseAction, GroupTarget } from '../types';
import * as NotificationsAPI from '../graphql-api/notifications';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';

type DonationAction = {
  amount: number
  payment_method: string
  checkout_data: any
  gateway_data: any
}

/**
 * Make a pressure to email using Notifications and Actions API
 * 
 * @param widget
 * @param activist
 */
export const create_email_pressure = async ({ widget, activist, action }: IBaseAction<DonationAction>): Promise<IActionData> => {
  const { amount, payment_method, checkout_data, gateway_data }: any = action || {};

  const donation: ActionsAPI.Donation = {
    widget_id: widget.id,
    mobilization_id: widget.block.mobilization.id,
    cached_community_id: widget.block.mobilization.community.id,
    activist_id: activist.id,
    email: activist.email,
    amount,
    payment_method,
    checkout_data,
    gateway_data
  }

  const { id, created_at } = await ActionsAPI.send_donation(donation);

  return {
    data: { id, created_at },
    // eslint-disable-next-line 
    syncronize: async () => { }
  }
}

export default makeActionResolver(create_email_pressure);