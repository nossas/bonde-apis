import create_domain from './create_domain';

const resolverMap = {
  Query: {},
  Mutation: {
    create_domain
  }
};

export default resolverMap;