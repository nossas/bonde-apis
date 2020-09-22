import { Register } from '../types';
import * as InvitationsAPI from '../graphql-api/invitations';
import * as UsersAPI from '../graphql-api/users';
import logger from '../logger';

type RegisterVerify = {
  email: string
  code: string
}

export default async (root: void, args: RegisterVerify): Promise<Register> => {
  const { email, code } = args

  // Validate fields
  // find throw error when not found
  const invite = await InvitationsAPI.find({ code, email });
  const user = (await UsersAPI.find({ email }))[0];

  logger.child({ invite, user }).info('register_verify');

  if (user) {
    // Relationship community and users
    await UsersAPI.relationship({ role: invite.role, community_id: invite.community.id, user_id: user.id });
    // Done invite to not reuse
    await InvitationsAPI.done(invite.id);
    // Response to client that users has relationship
    return { code, email, is_new_user: false };
  }

  // Response to client should continuous register user
  return { code, email, is_new_user: true };
};