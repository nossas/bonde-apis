import md5 from 'md5';
import urljoin from 'url-join';
import * as NotificationsAPI from '../graphql-api/notifications';
import * as CommunitiesAPI from '../graphql-api/communities';
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
  
  const community = CommunitiesAPI.get(community_id);

  if (!community) throw new Error('community_id not found');
  
  const code: string = md5(`${community_id}-${user_id}-${email}-${role}-${new Date().toISOString()}`);

  const registerUrl: string = process.env.ACCOUNTS_REGISTER_URL || 'http://accounts.bonde.devel:5000/register';
  const url: string = urljoin(registerUrl, `?code=${code}&email=${email}`);

  const notifyInput = {
    email_to: email,
    email_from: process.env.ACCOUNTS_EMAIL_FROM || 'suporte@bonde.org',
    context: { invite_url: url, community }
  }
  // Send email
  await NotificationsAPI.send(notifyInput, { label: 'invite', locale: 'pt-BR' });

  return {
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
    id: 123,
    user_id,
    role,
    email,
    community_id,
    code
  }
}

export default check_user(send_invitation, Roles.ADMIN);
