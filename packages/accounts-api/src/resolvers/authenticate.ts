import bcrypt from 'bcrypt';
import * as UsersAPI from '../graphql-api/users';
import { JWT } from '../types'
import { generateJWT } from '../utils'

type AuthenticateArgs = {
  email: string
  password: string
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export default async (_: void, args: AuthenticateArgs, { res }: any): Promise<JWT> => {
  const { email, password } = args;
  const errorCode = 'email_password_dismatch';
  let user;

  try {
    user = (await UsersAPI.find({ email }))[0];
  } catch (err) {
    console.log('authenticate error', err);
  }

  if (!user) throw new Error(errorCode);

  if (await bcrypt.compare(password, user.encrypted_password)) {
    const token = generateJWT(user);
    // set cookie
    const date = new Date();
    date.setDate(date.getDate() + 7);

    res.cookie('session', token,
      {
        expires: date,
        httpOnly: false,
        domain: process.env.NODE_ENV === 'production' ? '.bonde.org' : '.staging.bonde.org',
        secure: process.env.NODE_ENV === 'production' ? true : false,
      });

    return { valid: true, token, first_name: user.first_name };
  }

  throw new Error(errorCode);
};
