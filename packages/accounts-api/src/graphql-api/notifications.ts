import fetch from './client';
import logger from '../logger';

export interface Template {
  subject_template: string
  body_template: string
  locale: string
}

export interface FilterTemplate {
  locale: string
  label: string
}

export const findTemplate = async (filter: FilterTemplate): Promise<Template> => {
  const FilterNotificationTemplateQuery = `
		query findTemplate ($where: notification_templates_bool_exp) {
		  notification_templates(where: $where) {
		    subject_template
        body_template
        locale
		  }
		}
	`;

  const where = { label: { _eq: filter.label } };
  const resp = await fetch({ query: FilterNotificationTemplateQuery, variables: { where } });

  if (resp.data && resp.data.notification_templates.length > 0) {
    const template = resp.data.notification_templates.filter(
      (t: any) => t.locale.toLowerCase() === filter.locale.toLocaleLowerCase()
    )[0];
    if (template) return template
    else return resp.data.notification_templates[0];
  }

  throw new Error('template_not_found');
};

// "reset_password_instructions"

export interface Notify {
  email_to: string
  email_from: string
  subject?: string
  body?: string
  // eslint-disable-next-line @typescript-eslint/ban-types
  context?: object
}

export interface NotifyResponse {
  status: any
}

export const send = async (input: Notify, template?: FilterTemplate): Promise<NotifyResponse> => {
  logger.child({ template }).info('start notification...');
  if (template) {
    const { subject_template, body_template } = await findTemplate(template);
    input.subject = subject_template;
    input.body = body_template;
  }

  const insertMailMutation = `
    mutation SendMail ($input: [NotifyInput!]!){
      notify(input: $input) {
        status
      }
    }
  `;

  const { data, errors } = await fetch({ query: insertMailMutation, variables: { input } });

  logger.child({ data, errors }).info('done notification!');
  return data;
};