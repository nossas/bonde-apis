import { client } from "../../core/elasticsearchdb";

type ActivityFeedTotalArgs = {
  widget_id: number
}

type ActivityFeedEvent = {
  event_type: string
  total: number
}

type ActivityFeedTotalResult = {
  total: number
  events: ActivityFeedEvent[]
}

export default async (_: void, args: ActivityFeedTotalArgs): Promise<ActivityFeedTotalResult> => {
  const { widget_id } = args;
  const queryFilter = {
    "query": {
      "match": {
        "category": `w${widget_id}`
      }
    },
    "size": 0,
    "aggs": {
      "events_type": {
        "terms": {
          "field": "event"
        }
      }
    }
  };

  const { statusCode, body } = await client.search({
    index: "events-sendgrid-*",
    body: queryFilter
  });

  if (statusCode === 200) {
    return {
      total: body.hits.total.value,
      events: body.aggregations.events_type.buckets.map((event_bucket: any) => ({
        event_type: event_bucket.key,
        total: event_bucket.doc_count
      }))
    };
  }
  
  throw new Error("Failed elasticsearch with status: " + statusCode);
}