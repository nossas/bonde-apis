import client from "@sendgrid/client"
import dotenv from 'dotenv';

dotenv.config();

if (!process.env.SENDGRID_API_KEY) {
  throw new Error('Please specify the `SENDGRID_API_KEY` environment variable.');
}

client.setApiKey(process.env.SENDGRID_API_KEY || 'setup env');

type ActivityFeedFilter = {
  filter: {
    widget_id: number
  }
}

type Message = {
  from_email: string
  msg_id: string
  subject: string
  to_email: string
  status: string // 'delivered'
  opens_count: number
  clicks_count: number
  last_event_time: string
}

export default async (_: void, args: ActivityFeedFilter): Promise<{ messages: Message[] }> => {
  const request: any = {
    method: 'GET',
    url: '/v3/messages',
    qs: {
      limit: 10,
      query: `(Contains(categories,"pressure"))\AND\(Contains(categories,"w${args.filter.widget_id}"))`
    }
  };
  
  return client.request(request)
    .then(([response, body]) => {
      console.log(response.statusCode);
      console.log(body);
      
      return body
    })
    .catch((err) => {
      console.log("err", { body: err.response.body.errors });
    })
}