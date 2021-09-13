import logger from '../logger';
import mail from '@sendgrid/mail';
import dotenv from 'dotenv';

dotenv.config();

if (!process.env.SENDGRID_API_KEY) {
  throw new Error('Please specify the `SENDGRID_API_KEY` environment variable.');
}

mail.setApiKey(process.env.SENDGRID_API_KEY || 'setup env');

type Message = {
  to: string
  from: string
  subject: string
  html: string
  mail_settings?: any
  categories?: []
}

export const send = async (message: Message): Promise<void> => {
  if (process.env.NODE_ENV === 'development') {
    // Sandbox MODE
    message.mail_settings = {
      sandbox_mode: {
        enable: true
      }
    };
  }

  try {
    await mail.send(message);
  } catch (error) {
    logger.error(error);
    if (error.response) {
      const { headers, body } = error.response;
      console.log('headers', { headers });
      logger.error(body);
    }
  }
};