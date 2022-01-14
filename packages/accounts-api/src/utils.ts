import jwt from 'jsonwebtoken';
import config from './config';

type User = {
  id: number
  admin: boolean
  is_admin: boolean
}

export const generateJWT = (user: User): string => {
  const payload: JWT = {
    sub: 'postgraphql',
    role: user.admin ? 'admin' : 'common_user',
    user_id: user.id,
    is_admin: user.is_admin ? 1 : 0,
    "https://hasura.io/jwt/claims": {
      "x-hasura-allowed-roles": user.is_admin ? ['admin', 'user'] : ['user'],
      "x-hasura-default-role": user.is_admin ? 'admin' : 'user',
      "x-hasura-user-id": String(user.id)
    }
  };
  const options = { audience: 'postgraphile' };

  return jwt.sign(payload, config.jwtSecret, options);
};

type Role = 'admin' | 'user'

interface HasuraJWT {
  "x-hasura-allowed-roles": Role[]
  "x-hasura-default-role": Role
  "x-hasura-user-id": string
  // "x-hasura-org-id": "123",
  // "x-hasura-custom": "custom-value"
}


interface JWT {
  // Postgraphile Engine
  sub: 'postgraphql'
  role: 'admin' | 'common_user'
  user_id: number
  is_admin: 1 | 0 | boolean
  // audience: 'postgraphile'
  // Hasura Engine
  "https://hasura.io/jwt/claims": HasuraJWT
}