import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

test('should query api graphql and aws route53', async () => {
  const mockData = {
    dns_hosted_zones_by_pk: {
      hosted_zone: 'aaa.com',
      name_servers: 'aaaaa.com'
    }
  };
  const mockFn: any = {
    request: jest.fn().mockReturnValue(mockData)
  };

  // const mRes = { status: jest.fn().mockReturnThis(), json: jest.fn() };
  expect.assertions(2);
  const data = await DNSHostedZonesAPI.get(1, mockFn);
  expect(mockFn.request).toHaveBeenCalled();
  expect(data).toMatchObject(mockData.dns_hosted_zones_by_pk)
});