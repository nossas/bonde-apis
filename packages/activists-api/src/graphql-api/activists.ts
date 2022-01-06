import { ApolloError } from 'apollo-server-express';
import fetch from './client';
import logger from '../logger';
import { ActivistInput, Activist } from '../types';

export const queries = {
  get_or_create: `
    mutation CreateOrUpdateActivists (
      $activist: [activists_insert_input!]!
    ) {
        insert_activists(
          objects: $activist,
          on_conflict: {
            constraint: activists_email_key,
            update_columns: [name, first_name, last_name, phone, city, state]
          }
        ) {
          returning {
            id
            name
            first_name
            last_name
            email
            city
            phone
            state
          }
        }
    }
  `,
  unsyncronized_actions: `
    fragment activistFields on activists {
      id
      name
      first_name
      last_name
      email
      city
      phone
      state
    }

    fragment communitieFields on communities {
      id
      name
    }

    fragment mobilizationFields on mobilizations {
      id
      name
    }
    
    fragment widgetFields on widgets {
      id
      kind
    }

    query ActivistsActions ($community_id: Int!) {

      pressures: activist_pressures(where: { cached_community_id: { _eq: $community_id }, _or: [{ syncronized: { _is_null: true } }, { syncronized: { _eq: false } }] }) {
        id
        widget {
          ...widgetFields
        }
        mobilization {
          ...mobilizationFields
        }
        community {
          ...communitieFields
        }
        activist {
          ...activistFields
        }
      }

      donations(where: { cached_community_id: { _eq: $community_id }, _or: [{ syncronized: { _is_null: true } }, { syncronized: { _eq: false } }] }) {
        id
        widget {
          ...widgetFields
        }
        mobilization {
          ...mobilizationFields
        }
        community {
          ...communitieFields
        }
        activist {
          ...activistFields
        }
      }

      form_entries(where: { cached_community_id: { _eq: $community_id }, _or: [{ syncronized: { _is_null: true } }, { syncronized: { _eq: false } }] }) {
        id
        widget {
          ...widgetFields
        }
        mobilization {
          ...mobilizationFields
        }
        community {
          ...communitieFields
        }
        activist {
          ...activistFields
        }
      }
    }
  `
};

export const get_or_create = async (activist: ActivistInput): Promise<Activist> => {   
  const { data, errors }: any = await fetch({
    query: queries.get_or_create,
    variables: { activist }
  });

  if (!!data) {
    return data.insert_activists.returning[0];
  }
  throw new ApolloError(errors[0].message, 'actvists_get_or_create_error');
};

type Widget = {
  id: number
  kind: string
}

type Model = {
  id: number
  name: string
}

export type Action = {
  widget: Widget
  mobilization: Model
  community: Model
  activist: Activist
}

type Data = {
  donations: Action[]
  form_entries: Action[]
  pressures: Action[]
}

type GraphQLResponse = {
  data: Data
  errors?: any
}

export const unsyncronized_actions = async (community_id: number): Promise<Action[]> => {
  const { data, errors }: GraphQLResponse = await fetch({
    query: queries.unsyncronized_actions,
    variables: { community_id }
  });

  logger.child({ errors }).info('activists.unsyncronized_actions');

  const { donations, form_entries, pressures } = data;
  return [...donations, ...form_entries, ...pressures];
}