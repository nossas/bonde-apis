import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  host: string
  logLevel: string
  hasuraSecret?: string
  graphqlHttpUrl?: string
  jwtToken?: string
}

const config: Config = {
  port: process.env.PORT || 3000,
  host: process.env.HOST || 'localhost',
  logLevel: process.env.LOG_LEVEL || 'info',
  hasuraSecret: process.env.HASURA_SECRET,
  graphqlHttpUrl: process.env.GRAPHQL_HTTP_URL,
  jwtToken: process.env.JWT_TOKEN
};

export default config;