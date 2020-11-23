import create_volunteer_ticket from './create_volunteer_ticket'
import update_recipient_ticket from './update_recipient_ticket'
// import create_match from './create_match'

const resolverMap = {
  Query: {},
  Mutation: {
    create_volunteer_ticket,
    update_recipient_ticket
    // create_match,
  }
};

export default resolverMap;