import fetch from './client';

interface NotifyInput {
  body: string
  context?: any
  email_from: string
  email_to: string
  subject: string
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