import logger, { apmAgent } from "../../logger";
import { client } from "../../core/elasticsearchdb";

interface EmailStatsResponse {
  message: string
}

interface EmailStatsArgs {
  widget_id: number
}


export default async (_: void, args: EmailStatsArgs): Promise<EmailStatsResponse> => {
  const query = {
    match: {
      category: `autofire`
    }
  };
  const { statusCode, body } = await client.search({
    index: "events-sendgrid-*",
    body: { query: query }
  });
  
  return { message: "Olá Mario e Miguel! Total de eventos filtrados por autofire: " + body.hits.total.value }
  // throw new Error("Failed elasticsearch with status: " + statusCode);
}