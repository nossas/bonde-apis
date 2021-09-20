// import logger, { apmAgent } from "../../logger";
import { client } from "../../core/elasticsearchdb";

type ActivityFeedFilter = {
  filter: {
    widget_id: number
  }
}

type ActivityEvent = {
  event_type: string
  total: number
}

type ActivityFeed = {
  email: string
  total: number
  events: ActivityEvent[]
}

interface Bucket {
  key: string
  doc_count: number
}

interface EmailBucket extends Bucket {
  events: {
    buckets: Bucket[]
  }
}

export default async (_: void, args: ActivityFeedFilter): Promise<{ data: ActivityFeed[] }> => {
  const { filter: { widget_id } } = args;

  const { statusCode, body } = await client.search({
    index: "events-sendgrid-*",
    body: {
      query: {
        match: {
          category: `w${widget_id}`
        }
      },
      size: 0,
      aggs: {
        emails: {
          terms: {
            field: "email"
          },
          aggs: {
            events: {
              terms: {
                field: "event"
              }
            }
          }
        }
      }
    }
  });

  if (statusCode === 200) {
    return {
      data: body.aggregations.emails.buckets.map((email_bucket: EmailBucket) => ({
        email: email_bucket.key,
        total: email_bucket.doc_count,
        events: email_bucket.events.buckets.map((event_bucket: Bucket) => ({
          event_type: event_bucket.key,
          total: event_bucket.doc_count
        }))
      }))
    };
  }
  
  throw new Error("Failed elasticsearch with status: " + statusCode);
}