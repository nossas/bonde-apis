import fetch from './client';
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
            update_columns: [name, first_name, last_name, phone, city]
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
          }
        }
    }
  `
};

export const get_or_create = async (activist: ActivistInput): Promise<Activist> => {   
  const { data }: any = await fetch({
    query: queries.get_or_create,
    variables: { activist }
  });

  return data.insert_activists.returning[0];
};