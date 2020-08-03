import * as UsersAPI from '../graphql-api/users';
import { JWT } from '../types';
import authenticate from './authenticate';
import { generateJWT } from '../utils';

const users: UsersAPI.User[] = [
  {
    id: 234,
    first_name: 'Success',
    email: 'success@test.org',
    encrypted_password: 'adasxasdasvasdasd',
    admin: true,
    is_admin: false
  }
];

jest.mock('../graphql-api/users', () => ({
  find: async ({ email }: any): Promise<UsersAPI.User[]> => {
    return users.filter(u => u.email === email);
  }
}));

jest.mock('bcrypt', () => ({
  compare: async (password: string, encrypted: string): Promise<boolean> => {
    return password === encrypted;
  }
}));

describe('authenticate resolvers function', () => {

  it('should throw email_password_dismatch when not found email user', () => {
    return authenticate(undefined, { email: 'fail@test.org', password: 'sdasdas' })
      .catch((err) => {
        expect(err).toEqual(new Error('email_password_dismatch'));
      });
  });

  it('should throw email_password_dismatch when not pass dismatch', () => {
    return authenticate(undefined, { email: 'success@test.org', password: 'sdasdas' })
      .catch((err) => {
        expect(err).toEqual(new Error('email_password_dismatch'));
      });
  });

  it('should return JWT when success login', () => {
    return authenticate(undefined, { email: users[0].email, password: users[0].encrypted_password })
      .then((data: JWT) => {
        expect(data).toEqual({
          valid: true,
          token: generateJWT(users[0]),
          first_name: users[0].first_name
        });
      });
  });
});