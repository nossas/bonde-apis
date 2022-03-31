// Mock de certificates redis API (Padrão para todos os testes)
const mockCreateWildcard = jest.fn();
const mockCreateRouters = jest.fn();

jest.mock('../redis-db/certificates', () => ({
  createWildcard: mockCreateWildcard,
  createRouters: mockCreateRouters
}))

import CertificatesController from './certificates-controller';

describe('Certificates controller', () => {
  // Mock de clients externos API e Redis (Padrão para todos os testes)
  const mockGraphQLClient = {
    request: jest.fn()
  }

  beforeEach(() => {
    jest.clearAllMocks();
  })

  describe('certificate is create', () => {
    // Mock de entradas da função (Padrão para testes que criam certificado)
    const dns = {
      id: 4,
      community_id: 1,
      domain_name: 'test.org',
      ns_ok: true
    };
    const request = {
      body: {
        event: {
          data: {
            new: dns
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
      mockGraphQLClient.request.mockResolvedValueOnce({ mobilizations: [] });
      mockGraphQLClient.request.mockResolvedValueOnce({ insert_certificates_one: result });
  
      const certificatesController = new CertificatesController(mockGraphQLClient);
      await certificatesController.create(request, response);
    
      expect(response.status.mock.calls[0][0]).toBe(200);
      expect(mockJson.mock.calls[0][0]).toBe(result);
    });
  
    it('should create traefik router with wildcard in redis', async () => {
      mockGraphQLClient.request.mockResolvedValueOnce({ mobilizations: [] });

      const certificatesController = new CertificatesController(mockGraphQLClient);
      await certificatesController.create(request, response);

      const tRouterName = `${request.body.event.data.new.id}-${request.body.event.data.new.domain_name.replace('.', '-')}`;

      expect(mockCreateWildcard.mock.calls[0]).toEqual([tRouterName, request.body.event.data.new.domain_name])
    });

    it('should create traefik routers for subdomains in redis', async () => {
      const mobilizations = [
        { id: 1, community_id: 2, custom_domain: `www.campaign0.${dns.domain_name}` },
        { id: 2, community_id: 2, custom_domain: `www.campaign1.${dns.domain_name}` }
      ]
      
      mockGraphQLClient.request.mockResolvedValue({ mobilizations });

      const certificatesController = new CertificatesController(mockGraphQLClient);
      await certificatesController.create(request, response);
      const routerName = `${request.body.event.data.new.id}-${request.body.event.data.new.domain_name.replace('.', '-')}-www`;

      expect(mockCreateRouters.mock.calls[0])
        .toEqual([routerName, mobilizations.map(m => m.custom_domain)])
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
      const certificatesController = new CertificatesController(mockGraphQLClient);
      await certificatesController.create(request, response);

      expect(response.status.mock.calls[0][0]).toEqual(402);
      expect(mockJson.mock.calls[0][0]).toEqual({ message: 'Certificate not created because ns_ok is false.' });
    });
  });
})

