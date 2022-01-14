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
  console.log("authenticate", { args, res });
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
    const sevenDaysToSeconds = 7 * 24 * 60 * 60;
    res.cookie('session', token,
      {
        maxAge: sevenDaysToSeconds,
        httpOnly: false,
        domain: process.env.NODE_ENV === 'production' ? '.bonde.org' : '.staging.bonde.org',
        secure: process.env.NODE_ENV === 'production' ? true : false,
      });
    console.log("set-cookie", res);

    return { valid: true, token, first_name: user.first_name };
  }

  throw new Error(errorCode);
};
