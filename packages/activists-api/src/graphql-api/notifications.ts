import fetch from './client';

export interface Attachment {
  content: any
  filename: string
  // type: "application/pdf",
  type: string
  // disposition: "attachment"
  disposition: string
}

interface NotifyInput {
  body: string
  context?: any
  attachments?: Attachment[]
  email_from: string
  email_to: string
  subject: string
}

export interface Result {
  message_id: string
  payload: any
}

export interface NotifyResponse {
  status: string
  results: Result[]
}

export const queries = {
  send: `
    mutation Notify($input: [NotifyInput!]!) {
      notify(input: $input) {
        status
      }
    }
  `
};

export const send = async (input: NotifyInput[] | NotifyInput): Promise<any> => {
  return await fetch({ query: queries.send, variables: { input } });
};