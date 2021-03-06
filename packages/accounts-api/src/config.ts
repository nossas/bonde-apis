import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  host: string
  logLevel: string
  graphqlHttpUrl: string
  jwtSecret: string
  jwtToken?: string
  hasuraSecret?: string
  accountsRegisterUrl: string
}

// Accounts API required a JWT_SECRET to create valid tokens
if (!process.env.JWT_SECRET)
  throw new Error('Please specify the `JWT_SECRET` environment variable.');

if (!process.env.GRAPHQL_HTTP_URL)
  throw new Error('Please specify the `GRAPHQL_HTTP_URL` environment variable.');

const config: Config = {
  port: process.env.PORT || 3000,
  host: process.env.HOST || 'localhost',
  logLevel: process.env.LOG_LEVEL || 'info',
  graphqlHttpUrl: process.env.GRAPHQL_HTTP_URL,
  jwtSecret: process.env.JWT_SECRET,
  jwtToken: process.env.JWT_TOKEN,
  hasuraSecret: process.env.HASURA_SECRET,
  accountsRegisterUrl: process.env.ACCOUNTS_REGISTER_URL || 'http://accounts.bonde.devel:5000/register'
};

export default config;