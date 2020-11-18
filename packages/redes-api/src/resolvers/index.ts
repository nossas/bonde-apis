import create_volunteer_ticket from './create_volunteer_ticket'
// import create_match from './create_match'
// import update_ticket from './update_ticket'

const resolverMap = {
  Query: {},
  Mutation: {
    create_volunteer_ticket
    // create_match,
    // update_ticket
  }
};

export default resolverMap;