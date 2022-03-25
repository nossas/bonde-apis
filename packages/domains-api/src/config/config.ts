import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  host: string
  logLevel: string
  graphqlHttpUrl?: string
  jwtSecret?: string
  jwtToken?: string
  hasuraSecret?: string
  awsAccessKey?: string
  awsSecretKey?: string
  awsRoute53Region: string
  awsRouteIp: string
}

const config: Config = {
  port: process.env.PORT || 3000,
  host: process.env.HOST || 'localhost',
  logLevel: process.env.LOG_LEVEL || 'info',
  jwtToken: process.env.JWT_TOKEN,
  jwtSecret: process.env.JWT_SECRET,
  hasuraSecret: process.env.HASURA_SECRET,
  graphqlHttpUrl: process.env.GRAPHQL_HTTP_URL,
  awsAccessKey: process.env.AWS_ACCESS_KEY,
  awsSecretKey: process.env.AWS_SECRET_KEY,
  awsRoute53Region: process.env.AWS_ROUTE53_REGION || 'sa-east-1',
  awsRouteIp: process.env.AWS_ROUTE_IP || 'localhost'
};

export default config;