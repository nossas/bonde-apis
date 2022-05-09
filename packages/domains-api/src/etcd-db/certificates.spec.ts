// 1. Criar um rota wildcard para o dominio principal subdomain / domain - Ex.: *.meurio.org.br meurio.org.br, auxiliomoradia.meurio.org.br
//
// 2. Criar uma rota para cada X subdominios com www - Ex.: www.auxiliomoradia.meurio.org.br, www.forapaes.meurio.org.br
// X = 100

const mockValue = jest.fn();
const mockPut = jest.fn().mockImplementation(() => ({
  value: mockValue
}));

const mockGet = jest.fn().mockImplementation(() => ({
  string: mockValue
}))

const mockPrefix = jest.fn().mockImplementation(() => ({
  strings: mockValue.mockImplementation(() => [])
}))
const mockGetAll = jest.fn().mockImplementation(() => ({
  prefix: mockPrefix
}))

jest.mock('./client', () => ({
  put: mockPut,
  get: mockGet,
  getAll: mockGetAll
}))

import { DNSHostedZone } from "../controllers/certificates-controller";
import { createWildcard, createRouters, getRouters } from "./certificates";

describe('Certificates Redis', () => {
  const dns: DNSHostedZone = {
    id: 1,
    community_id: 75,
    domain_name: 'nossas.link',
    is_external_domain: false
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('createWildcard is successfully', () => {
    const routerName = `${dns.id}-${dns.domain_name.replace('.', '-')}`;

    it('should register wildcard in redis', async () => {
      await createWildcard(routerName, dns.domain_name);

      expect(mockPut.mock.calls[0][0]).toEqual(`traefik/http/routers/${routerName}/tls`);
      expect(mockValue.mock.calls[0][0]).toEqual('true')

      expect(mockPut.mock.calls[1][0]).toEqual(`traefik/http/routers/${routerName}/tls/certresolver`);
      expect(mockValue.mock.calls[1][0]).toEqual('myresolver')

      expect(mockPut.mock.calls[2][0]).toEqual(`traefik/http/routers/${routerName}/rule`);
      expect(mockValue.mock.calls[2][0]).toEqual(`HostRegexp(\`${dns.domain_name}\`, \`{subdomain:.+}.${dns.domain_name}\`)`)

      expect(mockPut.mock.calls[3][0]).toEqual(`traefik/http/routers/${routerName}/tls/domains/0/main`);
      expect(mockValue.mock.calls[3][0]).toEqual(dns.domain_name)

      expect(mockPut.mock.calls[4][0]).toEqual(`traefik/http/routers/${routerName}/tls/domains/0/sans/0`);
      expect(mockValue.mock.calls[4][0]).toEqual(`*.${dns.domain_name}`)

      expect(mockPut.mock.calls[5][0]).toEqual(`traefik/http/routers/${routerName}/service`);
      expect(mockValue.mock.calls[5][0]).toEqual('public@docker')
    });
  });

  describe('getRouters', () => {
    it('should call get main configuration to domain', async () => {
      mockValue.mockReturnValueOnce('nossas.link');

      await getRouters(587, 'nossas.link');
      expect(mockGet.mock.calls[0][0]).toEqual('traefik/http/routers/587-nossas-link/tls/domains/0/main');
    });

    it('should call get subrouters configuration to domain', async () => {
      mockValue.mockReturnValueOnce('nossas.link');
      mockValue.mockReturnValueOnce([
        "traefik/http/routers/587-nossas-link-www-0/rule",
        "Host(`www.other1.nossas.link`, `www.other2.nossas.link`)",
        "traefik/http/routers/587-nossas-link-www-0/service",
        "public@docker",
        "traefik/http/routers/587-nossas-link-www-0/tls",
        "true",
        "traefik/http/routers/587-nossas-link-www-0/tls/certresolver",
        "myresolver"
      ])

      await getRouters(587, 'nossas.link');
      const routerName = `587-nossas-link`;
      expect(mockGetAll.mock.calls.length).toEqual(1);
      expect(mockPrefix.mock.calls[0][0]).toEqual(`traefik/http/routers/${routerName}-www`);
    });

    it('should return all routers configuration to domain', async () => {
      mockValue.mockReturnValueOnce('nossas.link');
      mockValue.mockReturnValueOnce([
        "traefik/http/routers/587-nossas-link-www-0/rule",
        "Host(`www.other1.nossas.link`, `www.other2.nossas.link`)",
        "traefik/http/routers/587-nossas-link-www-0/service",
        "public@docker",
        "traefik/http/routers/587-nossas-link-www-0/tls",
        "true",
        "traefik/http/routers/587-nossas-link-www-0/tls/certresolver",
        "myresolver"
      ])

      const routers = await getRouters(587, 'nossas.link');
      expect(routers).toEqual(['www.other1.nossas.link', 'www.other2.nossas.link']);
    });
  });

  describe('createRouters is successfully', () => {
    const routerName = `${dns.id}-${dns.domain_name.replace('.', '-')}-www`;
    const domainNames = [
      `www.campanha1.${dns.domain_name}`,
      `www.campanha2.${dns.domain_name}`,
      `www.campanha3.${dns.domain_name}`
    ]

    it('should register in redis a router with domainNames', async () => {
      await createRouters(routerName, domainNames);

      expect(mockPut.mock.calls[0][0]).toEqual(`traefik/http/routers/${routerName}-0/tls`);
      expect(mockValue.mock.calls[0][0]).toEqual('true');

      expect(mockPut.mock.calls[1][0]).toEqual(`traefik/http/routers/${routerName}-0/tls/certresolver`);
      expect(mockValue.mock.calls[1][0]).toEqual('myresolver');

      expect(mockPut.mock.calls[2][0]).toEqual(`traefik/http/routers/${routerName}-0/service`);
      expect(mockValue.mock.calls[2][0]).toEqual('public@docker');

      expect(mockPut.mock.calls[3][0]).toEqual(`traefik/http/routers/${routerName}-0/rule`);
      expect(mockValue.mock.calls[3][0]).toEqual(`Host(${domainNames.map((domain) => `\`${domain}\``).join(',')})`);
    });

    it('should register in redis a router every 100 domainNames', async () => {
      const manyDomainNames = Array.from({ length: 150 }, (_, index: number) => `www.campanha${index}.${dns.domain_name}`);

      await createRouters(routerName, manyDomainNames);

      expect(mockPut.mock.calls[0][0]).toEqual(`traefik/http/routers/${routerName}-0/tls`);
      expect(mockValue.mock.calls[0][0]).toEqual('true')
      expect(mockPut.mock.calls[1][0]).toEqual(`traefik/http/routers/${routerName}-1/tls`);
      expect(mockValue.mock.calls[1][0]).toEqual('true')

      expect(mockPut.mock.calls[2][0]).toEqual(`traefik/http/routers/${routerName}-0/tls/certresolver`);
      expect(mockValue.mock.calls[2][0]).toEqual('myresolver')
      expect(mockPut.mock.calls[3][0]).toEqual(`traefik/http/routers/${routerName}-1/tls/certresolver`);
      expect(mockValue.mock.calls[3][0]).toEqual('myresolver')

      expect(mockPut.mock.calls[4][0]).toEqual(`traefik/http/routers/${routerName}-0/service`);
      expect(mockValue.mock.calls[4][0]).toEqual('public@docker')
      expect(mockPut.mock.calls[5][0]).toEqual(`traefik/http/routers/${routerName}-1/service`);
      expect(mockValue.mock.calls[5][0]).toEqual('public@docker')

      expect(mockPut.mock.calls[6][0]).toEqual(`traefik/http/routers/${routerName}-0/rule`);
      expect(mockValue.mock.calls[6][0]).toEqual(`Host(${manyDomainNames.slice(0, 100).map((domain) => `\`${domain}\``).join(',')})`)
      expect(mockPut.mock.calls[7][0]).toEqual(`traefik/http/routers/${routerName}-1/rule`);
      expect(mockValue.mock.calls[7][0]).toEqual(`Host(${manyDomainNames.slice(100, 150).map((domain) => `\`${domain}\``).join(',')})`)
    });
  })
});