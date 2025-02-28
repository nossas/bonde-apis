import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken'
import config from '../config';
import { JWT } from '../types'
import * as UsersAPI from '../graphql-api/users'
import reset_password_verify from './reset_password_verify'

type ResetPasswordChangeArgs = {
  token: string
  password: string
}

export default async (root: void, args: ResetPasswordChangeArgs): Promise<JWT> => {
  const { token, password } = args;
  const decoded = await reset_password_verify(undefined, { token });

  const encrypted_password = await bcrypt.hash(password, 9);

  const user = await UsersAPI.update(decoded.id, { encrypted_password, reset_password_token: '' });

  if (!user) throw new Error('user_not_found');

  const payload = {
    sub: 'postgraphql',
    role: user.admin ? 'admin' : 'common_user',
    user_id: user.id
  };
  const options = { audience: 'postgraphile' };

  return { valid: true, token: jwt.sign(payload, config.jwtSecret, options), first_name: user.first_name };
};