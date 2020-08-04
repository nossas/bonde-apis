import fetch from './client';

export interface Community {
  id: number
  name: string
  image?: string
}

export interface Invite {
  id: number
  expired?: boolean
  expires: Date
  role: number
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