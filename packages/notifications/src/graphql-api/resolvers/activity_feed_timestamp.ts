import { client } from "../../core/elasticsearchdb";

type ActivityFeedTotalResult = {
  min_timestamp: number
  max_timestamp: number
}

export default async (): Promise<ActivityFeedTotalResult> => {
  const queryFilter = {
    "size": 0,
    "aggs": {
      "min_timestamp": {
        "min": {
          "field": "timestamp"
        }
      },
      "max_timestamp": {
        "max": {
          "field": "timestamp"
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
      min_timestamp: body.aggregations.min_timestamp.value,
      max_timestamp: body.aggregations.max_timestamp.value
    };
  }
  
  throw new Error("Failed elasticsearch with status: " + statusCode);
}