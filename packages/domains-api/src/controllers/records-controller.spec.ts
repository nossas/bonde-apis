import RecordsController from './records-controller';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

test('should create record domain', () => {
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

  const mockReq = ({
    body: {
      input: {
        value: "",
        name: "",
        ttl: "",
        record_type: "",
        hosted_zone_id: "",
        dns_hosted_zone_id: ""
      }
    }
  });
  const mockRes = {
    status: jest.fn().mockReturnThis(),
    json: jest.fn()
  };

  const recordsController = new RecordsController(mockFn, DNSHostedZonesAPI);
  recordsController.deleteRecords(mockReq, mockRes);

  expect(mockFn.request).toHaveBeenCalled();
  expect(recordsController).toHaveProperty('DNSHostedZonesAPI');
});