type HelloArgs = {
  name: string
};

const hello = (_: void, args: HelloArgs): string => {
  if (args.name) return `Hello, ${args.name}!`;
  
  return `Hello anonymous`;
};

const resolverMap = {
  Query: {
    hello
  },
  Mutation: {
    hello
  }
};

export default resolverMap;