import { GraphQLClient } from 'graphql-request';
import config from '../config/config';

const uri: string = config.graphqlHttpUrl || 'http://localhost:3000/graphql';

export const client = ((): GraphQLClient => {
  const headers = {}
  if (config.jwtToken) {
    headers['authorization'] = `Bearer ${config.jwtToken}`;
  } else if (config.hasuraSecret) {
    headers['x-hasura-admin-secret'] = config.hasuraSecret;
  }
  return new GraphQLClient(uri, {
    headers,
  });
})()

export default client;

export { gql } from 'graphql-request'