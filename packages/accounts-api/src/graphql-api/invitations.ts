import fetch from './client';
import logger from '../logger';

export interface Community {
  id: number
  name: string
  image?: string
}

export interface Invite {
  created_at: string
  expired?: any
  expires?: string
  id: number
  updated_at: string
  user_id: number
  role: number
  email: string
  community_id: number
  code: string
  community: Community
}

export interface FilterInvitation {
  code: string
  email: string
}

export const find = async (variables: FilterInvitation): Promise<Invite> => {
  const expires = new Date().toISOString().substring(0, 10);
  const FilterInvitationsQuery = `
    query Invitations($code: String!, $email: String!, $expires: timestamp!) {
      invitations(
        where: {
          _and: {
            code: { _eq: $code },
            email: { _eq: $email },
            expired: { _is_null: true },
            expires: { _gte: $expires }
          }
        }
      ) {
        id
        expired
        expires
        role
        user_id
        email
        created_at
        updated_at
        community_id
        code
        community {
          id
          name
          image
        }
      }
    }
  `;

  const resp = await fetch({
    query: FilterInvitationsQuery,
    variables: { ...variables, expires }
  });
  if (resp.data && resp.data.invitations.length > 0) {
    return resp.data.invitations[0];
  }

  throw new Error('invalid_invitation_code');
};

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const create = async (input: any): Promise<Invite> => {
  const CreateInvite = `
    mutation ($input: [invitations_insert_input!]!) {
      insert_invitations (
        objects: $input
      ) {
        returning {
          id
          expired
          expires
          role
          user_id
          email
          created_at
          updated_at
          community_id
          code
          community {
            id
            name
            image
          }
        }
      }
    }
  `;
  const { data, errors } = await fetch({ query: CreateInvite, variables: { input } });
  if (data && data.insert_invitations) return data.insert_invitations.returning[0];
  
  logger.child({ errors }).info('failed to create invite')
  throw new Error('failed_insert_invitations');
}

export const done = async (id: number): Promise<Invite> => {
  const UpdateInvitationQuery = `
    mutation UpdateInvitation ($id: Int!) {
      update_invitations(where: { id: { _eq: $id }}, _set: { expired: true }) {
        returning {
          id
          expired
          expires
          role
          community {
            id
            name
            image
          }
        }
      }
    }
  `;
  const variables = { id };
  const resp = await fetch({ query: UpdateInvitationQuery, variables });

  return resp.data.update_invitations.returning[0];
};