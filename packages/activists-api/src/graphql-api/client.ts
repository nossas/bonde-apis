import { createApolloFetch } from 'apollo-fetch';
import config from '../config';

const uri: string = config.graphqlHttpUrl || 'http://localhost:3000/graphql';

const apolloFetch = createApolloFetch({ uri });

const authMiddleware = ({ options }: any, next: any) => {
  if (!options.headers) {
    options.headers = {};
  }

  if (config.jwtToken) {
    options.headers['authorization'] = `Bearer ${config.jwtToken}`;
  } else if (config.hasuraSecret) {
    options.headers['x-hasura-admin-secret'] = config.hasuraSecret;
  }

  next();
};

apolloFetch.use(authMiddleware);

export default apolloFetch;