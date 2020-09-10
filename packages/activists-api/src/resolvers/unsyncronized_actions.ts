import * as activists from '../graphql-api/activists';
import logger from '../logger';

type ActionsFilter = {
  community_id: number
}

export default async (_: void, { community_id }: ActionsFilter): Promise<activists.Action[]> => {
  const actions = await activists.unsyncronized_actions(community_id);

  logger.child({ community_id, size: actions.length }).info('unsyncronized_actions');

  return actions;
}