import { Activist, ActivistPressure, Plip } from '../types';
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
  status: "sent" | "sent_optimized" | "awaiting_optimized" | "batch_optimized" | "exceeded_optimized" | "draft"
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
  pressure_optimized: `
    mutation ($input: [activist_pressures_insert_input!]!, $widget_id: Int!) {
      insert_activist_pressures(objects: $input) {
        returning {
          id
          created_at
        }
      }
      
      update_activist_pressures(
        where: {
          widget_id: { _eq: $widget_id },
          status: { _eq: "awaiting_optimized" }
        },
        _set: { status: "batch_optimized" }
      ) {
        returning {
          id
          activist {
            name
            email
          }
        }
      }
    }
  `,
  get_pressure_info: `
    query ($widget_id: Int!) {
      batch_count: activist_pressures_aggregate(
        where: {
          widget: { id: { _eq: $widget_id } },
          status: {
            _in: ["awaiting_optimized"]
          }
        }
      ) {
        aggregate {
          count
        }
      }
      
      mail_count: activist_pressures_aggregate(
        where: {
          widget: { id: { _eq: $widget_id } },
          status: {
            _in: ["draft", "sent", "sent_optimized"]
          }
        }
      ) {
        aggregate {
          count
        }
      }
    }
  `,
  pressure_sync_done: `
    mutation InsertActivistPressure($id: Int!, $sync_at: timestamp!) {
      update_activist_pressures(
        where: { id: { _eq: $id } },
        _set: {
          synchronized: true,
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
          synchronized: true,
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
  `,
  plip: `mutation InsertPlip($plip: [plips_insert_input!]!) {
    insert_plips (objects: $plip) {
      returning {
        id
        unique_identifier
      }
    }
  }
  `,
  
};

export const pressure = async (input: Pressure): Promise<ActivistPressure> => {
  const { data, errors } = await fetch({
    query: queries.pressure,
    variables: { input }
  });

  logger.child({ data, errors }).info('pressure');
  return data.insert_activist_pressures.returning[0];
};

type PressureOptimizedResult = {
  pressure: ActivistPressure
  batch_activists: Activist[]
}

export const pressure_optimized = async (input: Pressure, widgetId: number): Promise<PressureOptimizedResult> => {
  const { data, errors } = await fetch({
    query: queries.pressure_optimized,
    variables: { input, widget_id: widgetId }
  });

  logger.child({ data, errors }).info('pressure');
  return {
    pressure: data.insert_activist_pressures.returning[0],
    batch_activists: data.update_activist_pressures.returning.map((ap: ActivistPressure) => ap.activist)
  };
}

type PressureInfo = {
  batch_count: number
  mail_count: number
}

export const get_pressure_info = async (widgetId: number): Promise<PressureInfo> => {
  const { data, errors } = await fetch({
    query: queries.get_pressure_info,
    variables: { widget_id: widgetId }
  });

  logger.child({ data, errors }).info('get_pressure_info');
  return {
    batch_count: data.batch_count.aggregate.count,
    mail_count: data.mail_count.aggregate.count
  };
}

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

export const plip = async (plip: Plip): Promise<any> => {
  const { data } = await fetch({
    query: queries.plip,
    variables: { input: plip }
  });

  return data.insert_plips.returning[0];
};
