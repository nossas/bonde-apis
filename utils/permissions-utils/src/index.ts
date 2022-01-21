import { handle_get_permission, Options } from './permissions';

type Session = {
  sub: string
  role: string
  user_id: number
  iat: number
  aud: string
}

export type Context = {
  session: Session
}

export enum Roles {
  USER = 2,
  ADMIN = 1
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const handle_check_user = ({ fetch, logger }: Options) => (next: any, role: Roles | [Roles]) => async (_: void, args: any, context: Context) => {
  const get_permission = handle_get_permission({ fetch, logger });
  const { session }: Context = context;

  console.log("session", { session });
  if (session) {
    const { input: { community_id } } = args;
    // Get permission on API-GraphQL (Hasura)
    const { permission, user } = await get_permission({ user_id: session.user_id, community_id });
    // Execute only when role is permitted from relationship between community users
    const roleInArray = typeof role === 'number' ? [role] : role
    if (
      roleInArray.includes(permission?.role) || user.is_admin
    ) return next(_, args, context);
  }
  // Permission denied
  throw new Error('invalid_permission');
};

export { handle_context } from './context';
