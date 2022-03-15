import fetch from './client';
import logger from '../logger';
import { MatchTicket } from "../types"

export const queries = {
  create_match: `  
    mutation CreateSolidarityMatch($match: solidarity_matches_insert_input!) {
      insert_solidarity_matches_one(
        object: $match
        on_conflict: {
          constraint: solidarity_matches_individuals_ticket_id_volunteers_ticket__key
          update_columns: [
            created_at
            community_id
            individuals_user_id
            volunteers_user_id
            volunteers_ticket_id
            status
          ]
        }
      ) {
        created_at
        community_id
        individuals_user_id
        individuals_ticket_id
        volunteers_user_id
        volunteers_ticket_id
        status
      }
    }
  `,
};

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const create = async (match: MatchTicket): Promise<MatchTicket> => {
  try {
    const { data, ...props } = await fetch({
      query: queries.create_match,
      variables: { match }
    });

    logger.child({ props }).info('create_match');

    return data.insert_solidarity_matches_one;
  } catch (e: any) {
    logger.child({ e }).error('create_match');
    return e
  }
};
