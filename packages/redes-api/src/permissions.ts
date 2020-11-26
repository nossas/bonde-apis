import logger from './logger'
import fetch from './graphql-api/client';
import { handle_check_user } from 'permissions-utils';

export const check_user = handle_check_user({ fetch, logger });

export { Roles, Context } from 'permissions-utils';
