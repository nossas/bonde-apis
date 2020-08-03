import * as UsersAPI from '../graphql-api/users';
import authenticate from './authenticate';

type HelloArgs = {
  name: string
};

const hello = (_: void, args: HelloArgs): string => {
  if (!!args.name) return `Hello, ${args.name}!`;
  
  return `Hello anonymous`;
};

type FindArgs = {
  email: string
}

const find = async (_: void, args: FindArgs): Promise<string> => {
  const users = await UsersAPI.find({ email: args.email });

  if (users.length > 0) {
    return users[0].first_name;
  }
  
  return 'Not Found';
}

const resolverMap = {
  Query: {
    hello,
    find
  },
  Mutation: {
    hello,
    authenticate
  }
};

export default resolverMap;