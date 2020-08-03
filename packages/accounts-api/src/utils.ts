import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';

dotenv.config();

if (!process.env.JWT_SECRET)
  throw new Error('Please specify the `JWT_SECRET` environment variable.');


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

  return jwt.sign(payload, process.env.JWT_SECRET || 'not_found_secret', options);
};