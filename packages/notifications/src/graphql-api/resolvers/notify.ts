import { Mail, MailSettings } from '../../core';
import config from '../../config';
import logger from '../../logger';

const path = config.sendgridApiKey
  ? '../../core/sendgrid'
  : '../../core/smtp'
;

type NotifyArgs = {
  input: MailSettings[]
}

type Result = {
  status: 'ok' | 'failed'
  results: any[]
}

export default async (_: void, args: NotifyArgs): Promise<Result> => {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const { send } = require(path);
  const results = await Promise.all(args.input.map(async (settings: MailSettings) => {
    const mail = new Mail(settings).json();
    return await send(mail);
  }));
  
  console.log("results", { results });
  logger.child({ args, results }).info('Notify');
  return { status: 'ok', results: results };
};