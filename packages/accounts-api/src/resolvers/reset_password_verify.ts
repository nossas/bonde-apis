import jwt from 'jsonwebtoken'
import config from '../config';
import { DecodedJWT } from '../types'
import * as UsersAPI from '../graphql-api/users'

type ResetPasswordVerifyArgs = {
  token: string
}

export default async (root: void, args: ResetPasswordVerifyArgs): Promise<DecodedJWT> => {
  const { token } = args;
  const decoded = jwt.verify(token, config.jwtSecret) as DecodedJWT;

  console.log('decoded', decoded);
  if (!decoded) throw new Error('invalid_token');

  const expired_at = decoded.expired_at;
  const now = String(new Date().getTime()).substring(0, 10);
  if (Number(now) > Number(expired_at)) throw new Error('invalid_token');

  const user = (await UsersAPI.find({ id: decoded.id, reset_password_token: token }))[0];
  if (!user) throw new Error('invalid_token');

  return decoded;
};