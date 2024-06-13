import logger, { apmAgent } from "../../logger";
import { client } from "../../core/elasticsearchdb";

interface EmailEvent {
  email: string;
  event: string;
  timestamp: number;
  sg_event_id: string;
  sg_message_id: string;
  useragent: string;
  ip: string;
  url: string;
}

interface EmailStatsResponse {
  events: EmailEvent[];
}

interface EmailStatsArgs {
  widget_id: number;
}


export default async (_: void, args: EmailStatsArgs): Promise<EmailStatsResponse> => {
  const query = {
    bool: {
      should: [
        { match: { event: "delivered" } },
        { match: { event: "bounced" } },
        { match: { event: "processed" } },
        { match: { event: "click" } },
        { match: { event: "open" } }
      ]
    }
  };

  try {
    const { body } = await client.search({
      index: "events-sendgrid-*",
      body: { query: query }
    });

    const events = body.hits.hits.map((hit: any) => ({
      email: hit._source.email,
      event: hit._source.event,
      timestamp: hit._source.timestamp,
      sg_event_id: hit._source.sg_event_id,
      sg_message_id: hit._source.sg_message_id,
      useragent: hit._source.useragent,
      ip: hit._source.ip,
      url: hit._source.url
    }));

    return { events: events };
  } catch (error) {
    logger.error(`Failed to fetch email stats`);
    throw new Error(`Failed to fetch email stats`);
  }
};