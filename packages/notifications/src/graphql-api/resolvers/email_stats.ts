import logger, { apmAgent } from "../../logger";
import { client } from "../../core/elasticsearchdb";


interface EmailStatsResponse {
  total: number;
  stats: {
    processed?: number;
    delivered?: number;
    open?: number;
    unsubscribe?: number;
    bounce?: number;
    deferred?: number;
    dropped?: number;
    spamreport?: number;
    click?: number;
  };
}

interface EmailStatsArgs {
  widget_id: number;
  category?: string;
}

interface Bucket {
  key: 'processed' | 'delivered' | 'open' | 'unsubscribe' | 'bounce' | 'deferred' | 'dropped' | 'spamreport' | 'click';
  doc_count: number;
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
        }
      ]
    }
  };

  const aggs = {
    messages_count: {
      scripted_metric: {
        params: {
          fieldName: "sg_message_id"
        },
        init_script: "state.list = []",
        map_script: `
        if(params['_source'][params.fieldName] != null) 
          state.list.add(params['_source'][params.fieldName]);
        `,
        combine_script: "return state.list;",
        reduce_script: `
        Map uniqueValueMap = new HashMap();
        int count = 0;
        for(shardList in states) {
          if(shardList != null) {
            for(key in shardList) {
              if(!uniqueValueMap.containsKey(key)) {
                count +=1;
                uniqueValueMap.put(key, key); 
              }
            }
          }
        }
        return count;
        `
      }
    },
    "events_count": {
      "terms": {
        "field": "event"
      }
    }
  }

  try {
    const { body } = await client.search({
      index: "events-sendgrid-*",
      body: { query, aggs }
    });

    const stats = {};
    body.aggregations.events_count.buckets.forEach((item: Bucket) => {
      stats[item.key] = item.doc_count
    })

    return {
      total: body.aggregations.messages_count.value,
      stats
    };
  } catch (error) {
    console.log("error", error);
    logger.error(`Failed to fetch email stats`);78152
    throw new Error(`Failed to fetch email stats`);
  }
};