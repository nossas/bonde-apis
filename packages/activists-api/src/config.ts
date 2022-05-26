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
  awsRoute53Region: string
  awsRouteIp: string
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
  awsRoute53Region: process.env.AWS_ROUTE53_REGION || 'us-east-1',
  awsRouteIp: process.env.AWS_ROUTE_IP || 'http://localhost:9099'
};

export default config;
