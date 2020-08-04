import GraphQLJSON, { GraphQLJSONObject } from 'graphql-type-json';
import create_email_pressure from './create_email_pressure';
import create_form_entry from './create_form_entry';
import update_mailchimp_settings from './update_mailchimp_settings';

const resolverMap = {
  // Query: {
  //   helloWorld: (_: void, args: void): string => {
  //     return `Hello Worldddddd!`;
  //   }
  // },
  Mutation: {
    create_email_pressure,
    create_form_entry,
    update_mailchimp_settings
  },
  JSON: GraphQLJSON,
  JSONObject: GraphQLJSONObject
};

export default resolverMap;