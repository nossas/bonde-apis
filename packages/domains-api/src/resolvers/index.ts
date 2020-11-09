import create_domain from './create_domain';
import delete_domain from './delete_domain';
import create_record from './create_record';
import delete_records from './delete_records';

const resolverMap = {
  Query: {},
  Mutation: {
    create_domain,
    delete_domain,
    create_record,
    delete_records
  }
};

export default resolverMap;