import { GraphQLJSONObject } from 'graphql-type-json';
import notify from './notify';
import activity_feed from "./activity_feed";
import activity_feed_total from './activity_feed_total';

const resolverMap = {
  Query: {
    activity_feed,
    activity_feed_total
  },
  Mutation: {
    notify
  },
  JSON: GraphQLJSONObject
};

export default resolverMap;