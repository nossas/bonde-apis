import { GraphQLScalarType } from 'graphql'
import authenticate from './authenticate';
import reset_password_change from './reset_password_change';
import reset_password_request from './reset_password_request';
import reset_password_verify from './reset_password_verify';
import register_verify from './register_verify';
import register from './register';

const Void = new GraphQLScalarType({
  name: 'Void',

  description: 'Represents NULL values',

  serialize() {
    return null
  },

  parseValue() {
    return null
  },

  parseLiteral() {
    return null
  }
});

const resolverMap = {
  Query: {
    reset_password_verify,
    register_verify
  },
  Mutation: {
    authenticate,
    register,
    register_verify,
    reset_password_change,
    reset_password_request
  },
  Void
};

export default resolverMap;