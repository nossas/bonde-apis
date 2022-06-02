import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  host: string
  logLevel: string
  graphqlHttpUrl?: string
  jwtToken?: string
  hasuraSecret?: string
  awsAccessKey?: string
  awsSecretKey?: string
  awsEndpoint: string
  awsBucket: string
}

const config: Config = {
  port: process.env.PORT || 3000,
  host: process.env.HOST || 'localhost',
  logLevel: process.env.LOG_LEVEL || 'info',
  graphqlHttpUrl: process.env.GRAPHQL_HTTP_URL,
  jwtToken: process.env.JWT_TOKEN,
  hasuraSecret: process.env.HASURA_SECRET,
  awsAccessKey: process.env.AWS_ACCESS_KEY,
  awsSecretKey: process.env.AWS_SECRET_KEY,
  awsEndpoint: process.env.AWS_ENDPOINT || 'http://localhost:9099',
  awsBucket: process.env.AWS_BUCKET || 'plip-dev'
};

export default config;
