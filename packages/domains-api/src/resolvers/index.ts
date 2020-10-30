import create_domain from './create_domain';
import delete_domain from './delete_domain';

const resolverMap = {
  Query: {},
  Mutation: {
    create_domain,
    delete_domain
  }
};

export default resolverMap;