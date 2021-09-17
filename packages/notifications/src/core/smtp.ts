import { createTransport, SendMailOptions, SentMessageInfo } from 'nodemailer';
import dotenv from 'dotenv';
import logger, { apmAgent } from '../logger';
import config from '../config';
import { Message } from "./mail";

dotenv.config();

if (!config.smtpHost) throw new Error('Please specify the `SMTP_HOST` environment variable.');
if (!config.smtpPort) throw new Error('Please specify the `SMTP_PORT` environment variable.');
if (!config.smtpUser) throw new Error('Please specify the `SMTP_USER` environment variable.');
if (!config.smtpPass) throw new Error('Please specify the `SMTP_PASS` environment variable.');

export const send = async (message: Message): Promise<SentMessageInfo> => {
  const mailer = createTransport({
    host: config.smtpHost,
    port: config.smtpPort,
    secure: Number(config.smtpPort) === 465, // true for 465, false for other ports
    auth: {
      user: config.smtpUser, // generated ethereal user
      pass: config.smtpPass // generated ethereal password
    }
  } as SendMailOptions);

  try {
    return await mailer.sendMail(message);
  } catch (error) {
    apmAgent?.captureError(error);
    logger.error(error as any);
    throw new Error(error as any);
  }
};