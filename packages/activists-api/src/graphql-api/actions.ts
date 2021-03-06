import { ActivistPressure } from '../types';
import fetch from './client';
import logger from '../logger';

interface WidgetAction {
  activist_id: number
  cached_community_id: number
  mobilization_id: number
  widget_id: number
}


interface Pressure extends WidgetAction {
  targets?: any
}

export const queries = {
  pressure: `
    mutation InsertActivistPressure($input: [activist_pressures_insert_input!]!) {
      insert_activist_pressures(objects: $input) {
        returning {
          id
          created_at
        }
      }
    }
  `,
  pressure_sync_done: `
    mutation InsertActivistPressure($id: Int!, $sync_at: timestamp!) {
      update_activist_pressures(
        where: { id: { _eq: $id } },
        _set: {
          syncronized: true,
          mailchimp_syncronization_at: $sync_at
        }
      ) {
        returning {
          id
        }
      }
    }
  `,
  send_form: `
    mutation InsertFormEntry($input:  [form_entries_insert_input!]!) {
      insert_form_entries(objects: $input) {
        returning {
          id
          created_at
        }
      }
    }
  `,
  send_form_sync_done: `
    mutation InsertActivistPressure($id: Int!, $sync_at: timestamp!) {
      update_form_entries(
        where: { id: { _eq: $id } },
        _set: {
          syncronized: true,
          mailchimp_syncronization_at: $sync_at
        }
      ) {
        returning {
          id
        }
      }
    }
  `,
  send_donation: `
    mutation InsertDonation($input:  [donations_insert_input!]!) {
      insert_donations(objects: $input) {
        returning {
          id
          created_at
        }
      }
    }
  `
};

export const pressure = async (input: Pressure): Promise<ActivistPressure> => {
  const { data, errors } = await fetch({
    query: queries.pressure,
    variables: { input }
  });

  logger.child({ data, errors }).info('pressure');
  return data.insert_activist_pressures.returning[0];
};

type DoneOpts = {
  id: number
  sync_at: string | any
}

export const pressure_sync_done = async ({ id, sync_at }: DoneOpts): Promise<any> => {
  const { data } = await fetch({
    query: queries.pressure_sync_done,
    variables: { id, sync_at }
  });

  return data.update_activist_pressures.returning[0];
};

interface FormEntry extends WidgetAction {
  // JSON
  fields: string
}

export const send_form = async (form_entry: FormEntry): Promise<any> => {
  const { data } = await fetch({
    query: queries.send_form,
    variables: { input: form_entry }
  });

  return data.insert_form_entries.returning[0];
};

export const send_form_sync_done = async ({ id, sync_at }: DoneOpts): Promise<any> => {
  const { data } = await fetch({
    query: queries.send_form_sync_done,
    variables: { id, sync_at }
  });

  return data.update_form_entries.returning[0];
};

export interface Donation extends WidgetAction {
  amount: number
  payment_method: string
  checkout_data: any
  gateway_data: any
  email: string
}

export const send_donation = async (donation: Donation): Promise<any> => {
  const { data } = await fetch({
    query: queries.send_donation,
    variables: { input: donation }
  });

  return data.insert_donations.returning[0];
};