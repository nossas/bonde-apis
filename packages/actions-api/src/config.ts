import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  logLevel: string
}

const config: Config = {
  port: process.env.PORT || 3000,
  logLevel: process.env.LOG_LEVEL || 'info'
};

export default config;