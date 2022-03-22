import CertificatesController, {
  Request,
  //  Certificate, 
  DNSHostedZone
} from './certificates-controller';

test('should create certificate', () => {
  // const mockReq: Request<Certificate> = {
  //   body: {
  //     event: {
  //       data: {
  //         new: {
  //           domain: "lutarnaoecrime.org",
  //           id: 33,
  //         }
  //       }
  //     }
  //   }
  // };
  const mockReq: Request<DNSHostedZone> = {
    body: {
      event: {
        data: {
          new: {
            domain_name: "lutarnaoecrime.org",
            id: 33,
            community_id: 2
          }
        }
      }
    }
  };
  // const mockData = {
  //   dns_hosted_zones_by_pk: {
  //     hosted_zone: 'aaa.com',
  //     name_servers: 'aaaaa.com'
  //   }
  // };
  // const mockFn = {
  //   request: jest.fn().mockReturnValue({
  //     data: mockData,
  //     errors: {}
  //   })
  // };
  const mRes = { status: jest.fn().mockReturnThis(), json: jest.fn(), body: mockReq.body };

  const certificatesController = new CertificatesController(jest.fn(), jest.fn());
  certificatesController.create(mockReq, mRes);

  // expect(mRes.status).toBeCalled();
  expect(mRes.body).toBe(mockReq.body);
});
