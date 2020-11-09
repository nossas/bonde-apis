import create_domain from './create_domain';
import delete_domain from './delete_domain';
import create_record from './create_record';

const resolverMap = {
  Query: {},
  Mutation: {
    create_domain,
    delete_domain,
    create_record
  }
};

export default resolverMap;