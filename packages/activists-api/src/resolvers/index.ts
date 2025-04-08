import GraphQLJSON, { GraphQLJSONObject } from 'graphql-type-json';
import create_email_pressure from './create_email_pressure';
import create_form_entry from './create_form_entry';
import create_donation from './create_donation';
import update_mailchimp_settings from './update_mailchimp_settings';
import unsyncronized_actions from './unsyncronized_actions';
import create_plip from './create_plip';
import create_widget_action from './create_widget_action';

const resolverMap = {
  Query: {
    unsyncronized_actions
  },
  Mutation: {
    create_email_pressure,
    create_form_entry,
    create_donation,
    create_plip,
    create_widget_action,
    update_mailchimp_settings,
  },
  JSON: GraphQLJSON,
  JSONObject: GraphQLJSONObject
};

export default resolverMap;