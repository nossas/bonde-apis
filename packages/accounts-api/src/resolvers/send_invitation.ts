import md5 from 'md5';
import urljoin from 'url-join';
import logger from '../logger';
import config from '../config';
import * as NotificationsAPI from '../graphql-api/notifications';
import * as InvitationsAPI from '../graphql-api/invitations';
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

const send_invitation = async (_: void, args: Args): Promise<InvitationsAPI.Invite> => {
  const { input: { community_id, email, role, user_id } } = args;
  
  const code: string = md5(`${community_id}-${user_id}-${email}-${role}-${new Date().toISOString()}`);
  const url: string = urljoin(config.accountsRegisterUrl, `?code=${code}&email=${email}`);
  const expires: string = new Date(new Date().setDate(new Date().getDate() + 5)).toISOString();

  const invite = await InvitationsAPI.create({
    community_id,
    email,
    role,
    user_id,
    code,
    expired: false,
    expires
  })

  logger.child({ invite }).info('send_notification');

  const notifyInput = {
    email_to: email,
    email_from: process.env.ACCOUNTS_EMAIL_FROM || 'suporte@bonde.org',
    context: { invite_url: url, community: invite.community }
  }
  await NotificationsAPI.send(notifyInput, { label: 'invite', locale: 'pt-BR' });

  return invite;
}

export default check_user(send_invitation, Roles.ADMIN);
