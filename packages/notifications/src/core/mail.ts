import nunjucks from 'nunjucks';

export interface MailSettings {
  body: string
  subject: string
  email_to: string
  email_from: string
  attachments?: MessageAttachment[]
  context?: any
}

export interface MessageAttachment {
  content: any
  filename: string
  // type: "application/pdf",
  type: string
  // disposition: "attachment"
  disposition: string
}

export interface Message {
  to: string
  from: string
  subject: string
  html: string
  mail_settings?: any
  attachments?: MessageAttachment[]
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
      subject,
      attachments
    } = this.settings;

    const message: any = {
      to: email_to,
      from: email_from,
      attachments,
      subject: this.engine.renderString(subject, context),
      html: this.engine.renderString(this.get_body(), context)
    }

    let categories: string[] = [];
    if (context?.widget_id) {
      categories = [...categories, `w${context?.widget_id}`]
    }
    if (context?.mobilization_id) {
      categories = [...categories, `m${context?.mobilization_id}`]
    }
    if (context?.community_id) {
      categories = [...categories, `c${context?.community_id}`]
    }
    
    return {
      ...message,
      categories
    };
  }
}

export default Mail;