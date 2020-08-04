import jwt from 'jsonwebtoken';
import config from './config';

type User = {
  id: number
  admin: boolean
  is_admin: boolean
}

export const generateJWT = (user: User): string => {
  const payload = {
    sub: 'postgraphql',
    role: user.admin ? 'admin' : 'common_user',
    user_id: user.id,
    is_admin: user.is_admin ? 1 : 0
  };
  const options = { audience: 'postgraphile' };

  return jwt.sign(payload, config.jwtSecret, options);
};