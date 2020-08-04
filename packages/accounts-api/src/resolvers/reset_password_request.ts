import jwt from 'jsonwebtoken';
import config from '../config';
import * as UsersAPI from '../graphql-api/users';
import * as NotificationsAPI from '../graphql-api/notifications';

type ResetPasswordRequestArgs = {
  email: string
  locale: string
  callback_url: string
}

export default async (root: void, args: ResetPasswordRequestArgs): Promise<void> => {
  const { email, locale, callback_url } = args;

  // Find user on database
  const user = (await UsersAPI.find({ email }))[0];

  if (!user) throw new Error('user_not_found');

  // Token expires after 48 hours
  const today = new Date();
  const expired_at = new Date(today.setUTCDate(today.getUTCDate() + 2));
  const payload = {
    id: user.id,
    // fix timestamp to convert
    expired_at: String(expired_at.getTime()).substring(0, 10)
  };
  const hash = jwt.sign(payload, config.jwtSecret);
  await UsersAPI.update(user.id, { reset_password_token: hash });

  // TODO: settings email_from
  const notify = {
    email_from: 'suporte@bonde.org',
    email_to: user.email,
    context: { user: { callback_url, reset_password_token: hash } }
  };

  await NotificationsAPI.send(notify, { locale, label: 'reset_password_instructions' });
};