// import logger, { apmAgent } from "../../logger";
import { client } from "../../core/elasticsearchdb";

type ActivityFeedFilter = {
  filter: {
    widget_id: number
    offset: number
    after?: string
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

interface EmailBucket extends Omit<Bucket, "key"> {
  key: { email: string }
  events: {
    buckets: Bucket[]
  }
}

type AggregationField = {
  terms: {
    field: string
  }
}

type AggregationCompositeField = {
  size: number
  sources: {
    email: AggregationField
  }[]
  after?: { email: string }
}

type ActivityFeedResult = {
  data: ActivityFeed[]
  after?: string
}

export default async (_: void, args: ActivityFeedFilter): Promise<ActivityFeedResult> => {
  const {
    filter: {
      widget_id,
      offset,
      after
    }
  } = args;
  const query = {
    match: {
      category: `w${widget_id}`
    }
  };
  const aggs_emails: AggregationCompositeField = {
    size: offset,
    sources: [
      {
        email: {
          terms: {
            field: "email"
          }
        }
      }
    ]
  };
  const aggs_events: AggregationField = {
    terms: {
      field: "event"
    }
  };
  if (after) {
    aggs_emails.after = {
      email: after
    }
  }

  const { statusCode, body } = await client.search({
    index: "events-sendgrid-*",
    body: {
      query: query,
      size: 0,
      aggs: {
        emails: {
          composite: aggs_emails,
          aggs: {
            events: aggs_events
          }
        }
      }
    }
  });

  if (statusCode === 200) {
    return {
      data: body.aggregations.emails.buckets.map((email_bucket: EmailBucket) => ({
        email: email_bucket.key.email,
        total: email_bucket.doc_count,
        events: email_bucket.events.buckets.map((event_bucket: Bucket) => ({
          event_type: event_bucket.key,
          total: event_bucket.doc_count
        }))
      })),
      after: body.aggregations.emails.after_key?.email || undefined
    };
  }
  
  throw new Error("Failed elasticsearch with status: " + statusCode);
}