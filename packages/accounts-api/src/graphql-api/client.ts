import dotenv from 'dotenv'
import { createApolloFetch } from 'apollo-fetch';

dotenv.config();

const uri: string = process.env.GRAPHQL_HTTP_URL || 'http://localhost:3000/graphql'

const apolloFetch = createApolloFetch({ uri });

const authMiddleware = ({ options }: any, next: any) => {
  if (!options.headers) {
    options.headers = {};
  }

  if (process.env.JWT_TOKEN) {
    options.headers['authorization'] = `Bearer ${process.env.JWT_TOKEN}`;
  } else if (process.env.HASURA_SECRET) {
    options.headers['x-hasura-admin-secret'] = process.env.HASURA_SECRET;
  }

  next();
};

apolloFetch.use(authMiddleware);

export default apolloFetch;