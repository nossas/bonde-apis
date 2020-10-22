const CommunityUsersQuery = `
  query CheckPermissions($user_id: Int!, $community_id: Int!) {
    user: users_by_pk(id: $user_id) {
      is_admin
    }
    community_users(where: { user_id: { _eq: $user_id }, community_id: { _eq: $community_id } }) {
      role
    }
  }
`;

type Args = {
  user_id: number
  community_id: number
}

type Permission = {
  role: number
}

type User = {
  is_admin: boolean
}

type PermissionResult = {
  user: User
  permission: Permission
}

export type Options = {
  fetch: any
  logger?: any
}

export const handle_get_permission = ({ fetch, logger }: Options) => async ({ user_id, community_id }: Args): Promise<PermissionResult> => {
  const { data, errors }: any = await fetch({
    query: CommunityUsersQuery,
    variables: { user_id, community_id }
  });

  logger?.child({ data, errors }).info('permissions.verify');

  const permission: Permission = data.community_users[0];

  return { permission, user: data.user };
}