import logger from '../logger';
import mail from '@sendgrid/mail';
import dotenv from 'dotenv';
import { Message } from "./mail";

dotenv.config();

if (!process.env.SENDGRID_API_KEY) {
  throw new Error('Please specify the `SENDGRID_API_KEY` environment variable.');
}

mail.setApiKey(process.env.SENDGRID_API_KEY || 'setup env');

type SengridMessage = {
  message_id: string
  payload: Message
}

export const send = async (message: Message): Promise<SengridMessage> => {
  if (process.env.NODE_ENV === 'development') {
    // Sandbox MODE
    message.mail_settings = {
      sandbox_mode: {
        enable: true
      }
    };
  }

  try {
    const resp = await mail.send(message);
    return {
      message_id: resp[0].headers["x-message-id"],
      payload: message
    };
  } catch (error) {
    if ((error as any).response) {
      const { body } = (error as any).response;
      logger.child({ body }).error("sendgrid api failed");
    }
    throw new Error(error as any);
  }
};