import * as ActivistsAPI from './activists';

jest.mock('./client', () => jest.fn().mockImplementation(() => ({
  data: undefined,
  errors: [
    { message: 'failed' }
  ]
})));

describe('graphql-api/activists', () => {
  const activist = {
    name: 'Test name',
    email: 'test@email.org'
  }

  it('throw ApolloError when failed request', async () => {
    await expect(ActivistsAPI.get_or_create(activist))
      .rejects
      .toThrow('failed')
  });
})