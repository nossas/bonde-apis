jest.mock('../route53', () => ({
  fetch_records: jest.fn().mockResolvedValue([]),
  create_or_update_hosted_zone: jest.fn().mockResolvedValue({
    HostedZone: { id: 234 }
  })
}))

import DomainsController from './domains-controller';
// import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

test('should create domain', () => {
  const mockDNSHostedZonesAPI: any = {
    find: jest.fn().mockResolvedValue([
      { community_id: 1 }
    ]),
    upsert: jest.fn().mockResolvedValue({
      id: 356
    }),
    records_upsert: jest.fn()
  }

  const mockReq: any = {
    body: {
      input: {
        domain: {
          domain_name: "foo.com",
          comment: "criado por robo",
          community_id: 1,
        }
      }
    }
  };
  const mockData = {
    dns_hosted_zones_by_pk: {
      hosted_zone: 'aaa.com',
      name_servers: 'aaaaa.com'
    }
  };
  const mockFn: any = {
    request: jest.fn().mockReturnValue({
      data: mockData,
      errors: {}
    })
  };
  const mRes = { status: jest.fn().mockReturnThis(), json: jest.fn() };

  const domainsController = new DomainsController(mockDNSHostedZonesAPI, mockFn);
  domainsController.createDomains(mockReq, mRes);

  expect(mockDNSHostedZonesAPI.find.mock.calls.length).toEqual(1);
  expect(domainsController).toHaveProperty('DNSHostedZonesAPI');
});