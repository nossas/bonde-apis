import { Client } from '@elastic/elasticsearch';
import config from "../config";

export const client = new Client({
  node: config.elasticsearchApiUrl
});