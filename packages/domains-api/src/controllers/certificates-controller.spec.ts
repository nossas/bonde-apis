// Mock de certificates redis API (Padrão para todos os testes)
const mockCreateWildcard = jest.fn();
const mockCreateRouters = jest.fn();
const mockGetRouters = jest.fn();

jest.mock('../etcd-db/certificates', () => ({
  createWildcard: mockCreateWildcard,
  createRouters: mockCreateRouters,
  getRouters: mockGetRouters
}))

import CertificatesController, { get_domain } from './certificates-controller';

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
    const request: any = {
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

    it('should call fetchMobilizationsByDomain', async () => {
      const certificatesController = new CertificatesController(mockGraphQLClient);
      await certificatesController.create(request, response);

      expect(mockGraphQLClient.request.mock.calls[0][0].variables).toEqual({
        domainName: `%${dns.domain_name}%`
      });
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

    it('should create only traefik routers for external domain in redis', async () => {
      const mobilizations = [
        { id: 1, community_id: 1, custom_domain: `www.${dns.domain_name}` }
      ]
      
      mockGraphQLClient.request.mockResolvedValue({ mobilizations });

      const certificatesController = new CertificatesController(mockGraphQLClient);
      await certificatesController.create({
        body: {
          event: {
            data: {
              new: {
                ...dns,
                is_external_domain: true
              }
            }
          }
        }
      }, response);
      const routerName = `${request.body.event.data.new.id}-${request.body.event.data.new.domain_name.replace('.', '-')}-external`;

      expect(mockCreateRouters.mock.calls[0])
        .toEqual([routerName, [...mobilizations.map(m => m.custom_domain), dns.domain_name]])
    });

    // it('should update certificate method', async () => {
    //   const certificate = { id: 2, domain: 'nossas.tec.br', dns_hosted_zone_id: 23 };
    //   mockGraphQLClient.request.mockResolvedValueOnce({ data: { certificate } });
    //   const mobilizations = [
    //     { id: 1, community_id: 1, custom_domain: `www.sudomain.nossas.tec.br` }
    //   ]
    //   mockGraphQLClient.request.mockResolvedValueOnce({ mobilizations });
      
    //   const certificatesController = new CertificatesController(mockGraphQLClient);
    //   await certificatesController.update({ body: { input: { id: certificate.id } } }, { json: jest.fn(), status: () => ({ json: jest.fn() }) });

    //   expect(mockGraphQLClient.request.mock.calls.length).toEqual(certificate.id);
    //   expect(mockGraphQLClient.request.mock.calls[0][0].variables).toEqual({ id: certificate.id });
    //   expect(mockGraphQLClient.request.mock.calls[1][0].variables).toEqual({ domainName: `%${certificate.domain}%` });

    //   const tRouterName = `${certificate.dns_hosted_zone_id}-${certificate.domain.replace('.', '-')}`;
    //   expect(mockCreateWildcard.mock.calls[0]).toEqual([tRouterName, certificate.domain]);

    //   const routerName = `${certificate.dns_hosted_zone_id}-${certificate.domain.replace('.', '-')}-www`;
    //   expect(mockCreateRouters.mock.calls[0])
    //     .toEqual([routerName, mobilizations.map(m => m.custom_domain)]);
    // });
  });

  describe('create_or_update_certificate', () => {
    // Mock input
    let certificatesController;
    const actionInput: any = {
      body: {
        input: { dns_hosted_zone_id: 524 }
      }
    }
    const mockJson = jest.fn();
    const mockRes = {
      status: jest.fn().mockImplementation(() => ({
        json: mockJson
      }))
    }

    beforeEach(() => {
      certificatesController = new CertificatesController(mockGraphQLClient);
    });

    it('should search domain with propagated status', async () => {
      await certificatesController.create_or_update(actionInput);
      expect(mockGraphQLClient.request.mock.calls[0][0]).toEqual({
        document: get_domain,
        variables: { id: actionInput.body.input.dns_hosted_zone_id }
      });
    });

    it('should return errors when domain not found', async () => {
      mockGraphQLClient.request.mockReturnValueOnce({ dns_hosted_zones_by_pk: null })
      await certificatesController.create_or_update(actionInput, mockRes);

      expect(mockRes.status.mock.calls[0][0]).toEqual(400);
      expect(mockJson.mock.calls[0][0]).toEqual({ message: 'domain_not_found' });
    });

    it('should return errors when domain is not propagated', async () => {
      mockGraphQLClient.request.mockReturnValueOnce({ dns_hosted_zones_by_pk: { ns_ok: false } })
      await certificatesController.create_or_update(actionInput, mockRes);

      expect(mockRes.status.mock.calls[0][0]).toEqual(400);
      expect(mockJson.mock.calls[0][0]).toEqual({ message: 'domain_not_propagated' });
    });

    it('should fetch traefik routers when domain is valid', async () => {
      mockGraphQLClient.request.mockReturnValueOnce({
        dns_hosted_zones_by_pk: {
          id: 587,
          domain_name: 'nossas.tec.br',
          ns_ok: true,
          certificates: [
            { id: 3, domain: 'nossas.tec.br', is_active: true }
          ]
        }
      });

      await certificatesController.create_or_update(actionInput, mockRes);
      expect(mockGetRouters.mock.calls[0]).toEqual([587, 'nossas.tec.br']);
    });

    it('should call createRouters when mobilizations custom domain not exists', async () => {
      mockGraphQLClient.request.mockReturnValueOnce({
        dns_hosted_zones_by_pk: {
          id: 587,
          domain_name: 'nossas.tec.br',
          ns_ok: true,
          certificates: [
            { id: 3, domain: 'nossas.tec.br', is_active: true }
          ]
        }
      });
      mockGraphQLClient.request.mockReturnValueOnce({
        mobilizations: [
          { id: 123, custom_domain: 'www.other1.nossas.tec.br' },
          { id: 124, custom_domain: 'www.other2.nossas.tec.br' },
          { id: 125, custom_domain: 'www.other3.nossas.tec.br' }
        ]
      });

      mockGetRouters.mockResolvedValueOnce(['nossas.tec.br', ['www.other1.nossas.tec.br', 'www.other2.nossas.tec.br']]);

      await certificatesController.create_or_update(actionInput, mockRes);
      expect(mockCreateRouters.mock.calls[0]).toEqual(
        [`587-nossas-tec-br-www`, ['www.other1.nossas.tec.br', 'www.other2.nossas.tec.br', 'www.other3.nossas.tec.br']]
      );
    });

    it('should call createRouters only subdomains', async () => {
      mockGraphQLClient.request.mockReturnValueOnce({
        dns_hosted_zones_by_pk: {
          id: 587,
          domain_name: 'nossas.tec.br',
          ns_ok: true,
          certificates: [
            { id: 3, domain: 'nossas.tec.br', is_active: true }
          ]
        }
      });
      mockGraphQLClient.request.mockReturnValueOnce({
        mobilizations: [
          { id: 122, custom_domain: 'www.nossas.tec.br' },
          { id: 123, custom_domain: 'www.other1.nossas.tec.br' },
          { id: 124, custom_domain: 'www.other2.nossas.tec.br' },
          { id: 125, custom_domain: 'www.other3.nossas.tec.br' }
        ]
      });

      mockGetRouters.mockResolvedValueOnce(['nossas.tec.br', ['www.other1.nossas.tec.br', 'www.other2.nossas.tec.br']]);

      await certificatesController.create_or_update(actionInput, mockRes);
      expect(mockCreateRouters.mock.calls[0]).toEqual(
        [`587-nossas-tec-br-www`, ['www.other1.nossas.tec.br', 'www.other2.nossas.tec.br', 'www.other3.nossas.tec.br']]
      );
    });

    it('should not call createRouters when mobilizations custom domain is settings', async () => {
      mockGraphQLClient.request.mockReturnValueOnce({
        dns_hosted_zones_by_pk: {
          id: 587,
          domain_name: 'nossas.tec.br',
          ns_ok: true,
          certificates: [
            { id: 3, domain: 'nossas.tec.br', is_active: true }
          ]
        }
      });
      mockGraphQLClient.request.mockReturnValueOnce({
        mobilizations: [
          { id: 124, custom_domain: 'www.other2.nossas.tec.br' },
          { id: 125, custom_domain: 'www.other3.nossas.tec.br' },
          { id: 123, custom_domain: 'www.other1.nossas.tec.br' }
        ]
      });

      mockGetRouters.mockResolvedValueOnce(['nossas.tec.br', ['www.other3.nossas.tec.br', 'www.other1.nossas.tec.br', 'www.other2.nossas.tec.br']]);

      await certificatesController.create_or_update(actionInput, mockRes);
      expect(mockCreateRouters.mock.calls.length).toEqual(0);
    });

    it('should call create when certificates not find', async () => {
      jest.spyOn(certificatesController, 'create');

      mockGraphQLClient.request.mockReturnValueOnce({
        dns_hosted_zones_by_pk: {
          id: 587,
          domain_name: 'nossas.tec.br',
          ns_ok: true,
          certificates: []
        }
      });

      await certificatesController.create_or_update(actionInput, mockRes);
      expect(certificatesController.create.mock.calls.length).toEqual(1);
      expect(certificatesController.create.mock.calls[0][0]).toEqual({
        body: {
          event: {
            data: {
              new: {
                id: 587,
                domain_name: 'nossas.tec.br',
                ns_ok: true,
                certificates: []
              }
            }
          }
        }
      });
    });

    it('should call createWildcard when wildcard not found', async () => {
      mockGraphQLClient.request.mockReturnValueOnce({
        dns_hosted_zones_by_pk: {
          id: 587,
          domain_name: 'nossas.tec.br',
          ns_ok: true,
          certificates: [
            { id: 3, domain: 'nossas.tec.br', is_active: true }
          ]
        }
      });
      mockGraphQLClient.request.mockReturnValueOnce({
        mobilizations: [
          { id: 124, custom_domain: 'www.other2.nossas.tec.br' },
          { id: 125, custom_domain: 'www.other3.nossas.tec.br' },
          { id: 123, custom_domain: 'www.other1.nossas.tec.br' }
        ]
      });

      mockGetRouters.mockResolvedValueOnce([undefined, []]);

      await certificatesController.create_or_update(actionInput, mockRes);
      expect(mockCreateWildcard.mock.calls.length).toEqual(1);
      expect(mockCreateRouters.mock.calls.length).toEqual(1);
    });
  });

  describe('certificate is not create', () => {
    // Mock de entradas da função (Padrão para testes que não criam certificado)
    const request: any = {
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

