import { GraphQLJSONObject } from 'graphql-type-json';
import notify from './notify';

const hello = async (): Promise<string> => {
  return 'Hello';
}

const resolverMap = {
  Query: {
    hello
  },
  Mutation: {
    notify
  },
  JSON: GraphQLJSONObject
};

export default resolverMap;