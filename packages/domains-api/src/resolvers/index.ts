import create_or_update_recipient from './create_or_update_recipient';

const resolverMap = {
  Query: {},
  Mutation: {
    create_or_update_recipient
  }
};

export default resolverMap;