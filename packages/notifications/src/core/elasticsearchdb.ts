import { Client } from '@elastic/elasticsearch';
import config from "../config";

if (!config.elasticsearchCloudId) throw new Error("ELASTICSEARCH_CLOUD_ID should be environment.");
if (!config.elasticsearchPassword) throw new Error("ELASTICSEARCH_PASSWORD should be environment.");

export const client = new Client(config.devEnv && config.elasticsearchDevMode ? { nodes: [] } : {
  cloud: {
    id: config.elasticsearchCloudId
  },
  auth: {
    username: "elastic",
    password: config.elasticsearchPassword
  }
});