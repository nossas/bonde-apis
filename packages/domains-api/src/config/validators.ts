import { SessionVariables, Community } from "../types";

export const verify_permission = (
  session_variables: SessionVariables,
  community: Community,
  role: 'admin' | 'user' = 'user'
) => {
  if (session_variables["x-hasura-role"] === 'admin') {
    return true;
  }

  const profile = community.community_users.filter(
    (instance) => Number(instance.user_id) === Number(session_variables["x-hasura-user-id"])
  )[0];

  if (profile && (role === 'user' || (role === 'admin' && profile.role === 1))) {
    return true;
  }

  throw new Error('access-denied')
}