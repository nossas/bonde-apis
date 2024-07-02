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
  stats: {
    open: number;
    delivered: number;
    bounced: number;
    processed: number;
    click: number;
    total: number;
  };
}

interface EmailStatsArgs {
  widget_id: number;
  category?: string;
}


export default async (_: void, args: EmailStatsArgs): Promise<EmailStatsResponse> => {
  const { widget_id, category } = args;
  let categories: string[] = [];

  if (category)  {
    categories.push(`${category}-w${widget_id}`);
  }  else {
    categories.push(`w${widget_id}`);
  }
  const query = {
    bool: {
      must: [
        {
          terms: {
            "category.keyword": categories
          }
        },
        {
          bool: {
            should: [
              { match: { event: "delivered" } },
              { match: { event: "bounced" } },
              { match: { event: "processed" } },
              { match: { event: "click" } },
              { match: { event: "open" } }
            ]
          }
        }
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
      url: hit._source.url,
    }));

    const stats = {
      open: events.filter(event => event.event === "open").length,
      delivered: events.filter(event => event.event === "delivered").length,
      bounced: events.filter(event => event.event === "bounced").length,
      processed: events.filter(event => event.event === "processed").length,
      click: events.filter(event => event.event === "click").length,
      total: events.length
    };

    return { events, stats };
  } catch (error) {
    logger.error(`Failed to fetch email stats`);
    throw new Error(`Failed to fetch email stats`);
  }
};