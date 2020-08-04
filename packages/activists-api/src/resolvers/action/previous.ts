import { ApolloError } from 'apollo-server-express';
import * as ActivistsAPI from '../../graphql-api/activists';
import * as WidgetsAPI from '../../graphql-api/widgets';
import {
  Activist,
  Widget,
  IBaseActionArgs,
  IPreviousData
} from '../../types';

export default async (args: IBaseActionArgs): Promise<IPreviousData> => {
  // Fetch Widget Settings
  const widget: Widget = await WidgetsAPI.get(args.widget_id);
  // Throw Error Not Found
  if (!widget) throw new ApolloError('Widget Not Found', 'widget_not_found');
  // Create or Update Information about Activist on database
  const activist: Activist = await ActivistsAPI.get_or_create(args.activist);

  return { activist, widget };
};