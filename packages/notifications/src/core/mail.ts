import nunjucks from 'nunjucks';

export interface MailSettings {
  body: string
  subject: string
  email_to: string
  email_from: string
  context?: any
}

export interface Message {
  to: string
  from: string
  subject: string
  html: string
  mail_settings?: any
  categories?: []
}

class Mail {
  private engine = nunjucks;
  private settings: MailSettings

  constructor(settings: MailSettings) {
    this.settings = settings;
    this.engine.configure({ autoescape: true });
  }

  get_body (): string {
    if (new RegExp(/\<!DOCTYPE/).test(this.settings.body)) {
      return this.settings.body;
    }
    return this.settings.body.replace(/\n/g, '<br/>');
  }

  json (): Message {
    const {
      email_to,
      email_from,
      context,
      subject
    } = this.settings;

    const message: any = {
      to: email_to,
      from: email_from,
      subject: this.engine.renderString(subject, context),
      html: this.engine.renderString(this.get_body(), context)
    }

    if (context?.pressure) {
      message.categories = ["pressure", `w${context.pressure.widget_id}`]
    }
    
    return message;
  }
}

export default Mail;