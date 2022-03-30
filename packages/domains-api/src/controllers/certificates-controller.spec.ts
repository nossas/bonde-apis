const mockCreateWildcard = jest.fn();

jest.mock('../redis-db/certificates', () => ({
  createWildcard: mockCreateWildcard
}))

import CertificatesController from './certificates-controller';

describe('Certificates controller', () => {
  // Mock de clients externos API e Redis (Padrão para todos os testes)
  const mockGraphQLClient = {
    request: jest.fn()
  }
  const mockRedisClient = {
    connect: jest.fn(),
    set: jest.fn(),
    quit: jest.fn()
  };

  beforeEach(() => {
    jest.clearAllMocks();
  })

  describe('certificate is create', () => {
    // Mock de entradas da função (Padrão para testes que criam certificado)
    const request = {
      body: {
        event: {
          data: {
            new: {
              id: 4,
              community_id: 1,
              domain_name: 'test.org',
              ns_ok: true
            }
          }
        }
      }
    }
    const mockJson = jest.fn();
    const response: any = {
      status: jest.fn().mockImplementation(() => ({
        json: mockJson
      }))
    }

    it('should return graphql response to action', async () => {
      const result = {
        id: 3,
        dns_hosted_zone_id: request.body.event.data.new.id,
        is_active: false,
        community_id: request.body.event.data.new.community_id,
        domain: 'test.org',
      }
  
      // Mock de clients externos API e Redis
      mockGraphQLClient.request.mockResolvedValue({ insert_certificates_one: result });
  
      const certificatesController = new CertificatesController(mockRedisClient, mockGraphQLClient);
      await certificatesController.create(request, response);
    
      expect(response.status.mock.calls[0][0]).toBe(200);
      expect(mockJson.mock.calls[0][0]).toBe(result);
    });
  
    it('should create traefik routers in redis', async () => {
      const certificatesController = new CertificatesController(mockRedisClient, mockGraphQLClient);
      await certificatesController.create(request, response);

      const tRouterName = `${request.body.event.data.new.id}-${request.body.event.data.new.domain_name.replace('.', '-')}`;

      expect(mockCreateWildcard.mock.calls[0]).toEqual([tRouterName, request.body.event.data.new.domain_name])
    });
  });

  describe('certificate is not create', () => {
    // Mock de entradas da função (Padrão para testes que não criam certificado)
    const request = {
      body: {
        event: {
          data: {
            new: {
              id: 4,
              community_id: 1,
              domain_name: 'test.org',
              ns_ok: false
            }
          }
        }
      }
    }
    const mockJson = jest.fn();
    const response: any = {
      status: jest.fn().mockImplementation(() => ({
        json: mockJson
      }))
    }

    it('should return 400 when dns is not ok', async () => {
      const certificatesController = new CertificatesController(mockRedisClient, mockGraphQLClient);
      await certificatesController.create(request, response);

      expect(response.status.mock.calls[0][0]).toEqual(402);
      expect(mockJson.mock.calls[0][0]).toEqual({ message: 'Certificate not created because ns_ok is false.' });
    });
  });
})

