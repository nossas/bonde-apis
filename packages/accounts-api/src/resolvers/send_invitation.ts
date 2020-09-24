import { check_user, Roles } from '../permissions';

type InvitationInput = {
  community_id: number
  email: string
  role: number
  user_id: number
}

type Args = {
  input: InvitationInput
}

type Invite = {
  created_at: string
  expired?: any
  id: number
  updated_at: string
  user_id: number
  role: number
  email: string
  community_id: number
  code: string
}

const send_invitation = async (_: void, args: Args): Promise<Invite> => {
  const { input: { community_id, email, role, user_id } } = args;

  return {
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
    id: 123,
    user_id,
    role,
    email,
    community_id,
    code: 'asdasdasdasdasdasd'
  }
}

export default check_user(send_invitation, Roles.ADMIN)