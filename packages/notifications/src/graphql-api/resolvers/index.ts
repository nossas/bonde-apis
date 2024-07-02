import { GraphQLJSONObject } from 'graphql-type-json';
import notify from './notify';
import activity_feed from "./activity_feed";
import activity_feed_total from './activity_feed_total';
import activity_feed_timestamp from "./activity_feed_timestamp";
import email_stats from './email_stats';

const resolverMap = {
  Query: {
    activity_feed,
    activity_feed_total,
    activity_feed_timestamp,
    email_stats
  },
  Mutation: {
    notify
  },
  JSON: GraphQLJSONObject
};

export default resolverMap;