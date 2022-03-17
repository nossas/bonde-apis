import DomainsController from './domains-controller';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

test('should create domain', () => {
  const mockReq = {
    body: {
      domain: "foo.com",
      comment: "criado por robo",
      community_id: 1,
    }
  };
  const mockData = {
    dns_hosted_zones_by_pk: {
      hosted_zone: 'aaa.com',
      name_servers: 'aaaaa.com'
    }
  };
  const mockFn = {
    request: jest.fn().mockReturnValue({
      data: mockData,
      errors: {}
    })
  };
  const mRes = { status: jest.fn().mockReturnThis(), json: jest.fn() };

  const domainsController = new DomainsController(mockFn, DNSHostedZonesAPI);
  domainsController.createDomains(mockReq, mRes);

  expect(mockFn.request).toHaveBeenCalled();
  expect(domainsController).toHaveProperty('DNSHostedZonesAPI');
});