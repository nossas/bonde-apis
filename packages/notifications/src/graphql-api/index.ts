import { ApolloServer } from "apollo-server-express";
import depthLimit from 'graphql-depth-limit';
import schema from "./schema";

export const graphql = new ApolloServer({
  schema: schema,
  validationRules: [depthLimit(9)]
} as any);