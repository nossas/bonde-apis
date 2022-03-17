import CertificatesController from './certificates-controller';

test('should create certificate', () => {
  const mockReq = {
    body: {
      domain: "foo.com",
      comment: "criado por robo",
      community_id: 1,
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
  const mRes = { status: jest.fn().mockReturnThis(), json: jest.fn() };

  const certificatesController = new CertificatesController();
  certificatesController.createCertificate(mockReq, mRes);

  expect(mRes.json).toBeCalled();
});