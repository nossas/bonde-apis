import logger from '../../logger';
import mailchimp from '../../mailchimp';
import { DoneAction, IBaseAction } from '../../types';
import * as NotificationsAPI from '../../graphql-api/notifications';


export default async <T>({ activist, widget }: IBaseAction<T>, done: DoneAction): Promise<any> => {
  const { community } = widget.block.mobilization;
  // as an experimentation to plip, we filter widget by kind and will not sync mailchimp in these scenario
  if (community.mailchimp_api_key && community.mailchimp_list_id && widget.kind !== 'plip') {
    // Update Contact on Mailchimp
    const { subscribe } = mailchimp({ activist, widget });
    subscribe().then(done).catch((err: any) => {
      logger.child({ err }).error('subscribe mailchimp');
    });
  }

  // Post-action
  const { email_subject, sender_email, sender_name, email_text } = widget.settings;

  // TODO: Required fields to Notify "Pós-Ação"
  const notifyOpts: any = {
    email_from: community.email_template_from,
    email_to: `${activist.name} <${activist.email}>`,
    subject: email_subject,
    body: email_text
  };

  if (!!sender_name && !!sender_email) {
    notifyOpts.email_from = `${sender_name} <${sender_email}>`;
  }

  await NotificationsAPI.send(notifyOpts);

  logger.child({ activist, widget }).info('action is done');
};

// 0. trazer a função de processar pdf e inserir plip para remote schema
// 1. definir no settings da widget   const { email_subject, sender_email, sender_name, email_text } = widget.settings;
// 2. possibilitar que na pos acao seja possível passar um anexo