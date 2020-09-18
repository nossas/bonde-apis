import Mail, { MailSettings } from '../core/mail';
import config from '../config';
import logger from '../logger';

let path = '../core/smtp';

if (config.sendgridApiKey) {
  path = '../core/sendgrid';
}

logger.info(`Core snippet load on ${path}`);

type NotifyArgs = {
  input: MailSettings[]
}

export default async (_: void, args: NotifyArgs): Promise<{ status: string }> => {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const { send } = require(path);

  args.input.forEach(async (settings: MailSettings) => {
    const mail = new Mail(settings).json();
    await send(mail);
  });

  logger.child({ args }).info('Email sent to');
  return { status: 'ok' };
};