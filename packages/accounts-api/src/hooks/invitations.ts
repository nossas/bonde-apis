import md5 from 'md5'
import urljoin from 'url-join';
import * as InvitationsAPI from '../graphql-api/invitations';
import * as NotificationsAPI from '../graphql-api/notifications';

export interface Event<T> {
  event: {
    data: {
      new: T
    }
  }
}

export interface EventRequest<T> {
  body: Event<T>
  headers?: any
}

const TEMPLATE = {
  label: 'invite',
  locale: 'pt-BR'
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
const handle = async (req: EventRequest<InvitationsAPI.Invite>, res: any): Promise<any> => {
  const { id, community_id, user_id, email, role, created_at }: InvitationsAPI.Invite = req.body.event.data.new;
  const code: string = md5(`${community_id}-${user_id}-${email}-${role}-${created_at}`);

  // Update invite with code
  const invite = await InvitationsAPI.update(id, { code });
  // Prepare input mail
  const registerUrl: string = process.env.ACCOUNTS_REGISTER_URL || 'http://accounts.bonde.devel:5000/register';
  const url: string = urljoin(registerUrl, `?code=${invite.code}&email=${invite.email}`);
  const input = {
    email_to: invite.email,
    email_from: process.env.ACCOUNTS_EMAIL_FROM || 'suporte@bonde.org',
    context: { invite_url: url, community: invite.community }
  }
  // Send email
  await NotificationsAPI.send(input, TEMPLATE)
  // Done!
  return res
    .status(200)
    .json({ object_id: invite.id })
}

export default handle;

/**
 * Webhook
 * 
 * 1. check invited user exists
 * 2. generate code to confirm invite
 * 3. send url to confirm invite for user by email
 * 
 * API
 * 1. check invite code exists or expired (query)
 * 2. register user (mutation)
*/