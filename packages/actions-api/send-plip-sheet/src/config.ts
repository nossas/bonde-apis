import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  awsAccessKey?: string
  awsSecretKey?: string
  awsRoute53Region: string
  awsRouteIp: string
}

const config: Config = {
  port: process.env.PORT || 3000,
  awsAccessKey: process.env.AWS_ACCESS_KEY,
  awsSecretKey: process.env.AWS_SECRET_KEY,
  awsRoute53Region: process.env.AWS_ROUTE53_REGION || 'sa-east-1',
  awsRouteIp: process.env.AWS_ROUTE_IP || 'localhost'
};

export default config;