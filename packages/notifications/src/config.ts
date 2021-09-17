import dotenv from 'dotenv';

dotenv.config();

type Config = {
  port: number | string
  host: string
  logLevel?: string
  sendgridApiKey?: string
  sendgridWebhookKey?: string
  smtpHost?: string
  smtpPass?: string
  smtpPort?: number | string
  smtpUser?: string
  elasticsearchApiUrl: string
  apmSecretToken?: string
  apmServerUrl?: string
  apmServiceName?: string
}

const config: Config = {
  port: process.env.PORT || 3001,
  host: process.env.HOST || 'localhost',
  logLevel: process.env.LOG_LEVEL,
  sendgridApiKey: process.env.SENDGRID_API_KEY,
  sendgridWebhookKey: process.env.SENDGRID_WEBHOOK_KEY,
  smtpHost: process.env.SMTP_HOST,
  smtpPass: process.env.SMTP_PASS,
  smtpPort: process.env.SMTP_PORT,
  smtpUser: process.env.SMTP_USER,
  elasticsearchApiUrl: process.env.ELASTICSEARCH_API_URL || 'http://es01.bonde.devel:9200',
  apmSecretToken: process.env.ELASTIC_APM_SECRET_TOKEN,
  apmServerUrl: process.env.ELASTIC_APM_SERVER_URL,
  apmServiceName: process.env.ELASTIC_APM_SERVICE_NAME
};

export default config;