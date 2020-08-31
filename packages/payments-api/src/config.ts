import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  host: string
  logLevel: string
  graphqlHttpUrl?: string
  jwtToken?: string
  hasuraSecret?: string
  pagarmeApiKey?: string
}

const config: Config = {
  port: process.env.PORT || 3000,
  host: process.env.HOST || 'localhost',
  logLevel: process.env.LOG_LEVEL || 'info',
  jwtToken: process.env.JWT_TOKEN,
  hasuraSecret: process.env.HASURA_SECRET,
  graphqlHttpUrl: process.env.GRAPHQL_HTTP_URL,
  pagarmeApiKey: process.env.PAGARME_API_KEY
};

export default config;