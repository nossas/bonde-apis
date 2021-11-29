import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  host: string
  logLevel: string
  graphqlHttpUrl?: string
  jwtToken?: string
  hasuraSecret?: string
}

const config: Config = {
  port: process.env.PORT || 3000,
  host: process.env.HOST || 'localhost',
  logLevel: process.env.LOG_LEVEL || 'info',
  graphqlHttpUrl: process.env.GRAPHQL_HTTP_URL,
  jwtToken: process.env.JWT_TOKEN,
  hasuraSecret: process.env.HASURA_SECRET
};

export default config;