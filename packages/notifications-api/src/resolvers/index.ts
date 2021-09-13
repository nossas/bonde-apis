import { GraphQLJSONObject } from 'graphql-type-json';
import notify from './notify';
import activity_feed from "./activity_feed";

const resolverMap = {
  Query: {
    activity_feed
  },
  Mutation: {
    notify
  },
  JSON: GraphQLJSONObject
};

export default resolverMap;