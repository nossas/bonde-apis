// 1. Criar um rota wildcard para o dominio principal subdomain / domain - Ex.: *.meurio.org.br meurio.org.br, auxiliomoradia.meurio.org.br
//
// 2. Criar uma rota para cada X subdominios com www - Ex.: www.auxiliomoradia.meurio.org.br, www.forapaes.meurio.org.br
// X = 100

const mockConnect = jest.fn();
const mockSet = jest.fn();
const mockQuit = jest.fn();

jest.mock('./client', () => ({
  connect: mockConnect,
  set: mockSet,
  quit: mockQuit
}))

import { DNSHostedZone } from "../controllers/certificates-controller";
import { createWildcard, createRouters } from "./certificates";

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
  
    it('should open and quit connect redis', async () => {
      await createWildcard(routerName, dns.domain_name);

      expect(mockConnect.mock.calls.length).toEqual(1);
      expect(mockQuit.mock.calls.length).toEqual(1);
    });

    it('should register wildcard in redis', async () => {
      await createWildcard(routerName, dns.domain_name);

      expect(mockSet.mock.calls[0]).toEqual([`traefik/http/routers/${routerName}/tls`, 'true']);
      expect(mockSet.mock.calls[1]).toEqual([`traefik/http/routers/${routerName}/tls/certresolver`, 'myresolver']);
      expect(mockSet.mock.calls[2]).toEqual([`traefik/http/routers/${routerName}/rule`, `HostRegexp(\`${dns.domain_name}\`, \`{subdomain:.+}.${dns.domain_name}\`)`]);
      expect(mockSet.mock.calls[3]).toEqual([`traefik/http/routers/${routerName}/tls/domains/0/main`, dns.domain_name]);
      expect(mockSet.mock.calls[4]).toEqual([`traefik/http/routers/${routerName}/tls/domains/0/sans/0`, `*.${dns.domain_name}`]);
      expect(mockSet.mock.calls[5]).toEqual([`traefik/http/routers/${routerName}/service`, 'public@docker']);
    });
  });

  describe('createRouters is successfully', () => {
    const routerName = `${dns.id}-${dns.domain_name.replace('.', '-')}-www`;
    const domainNames = [
      `www.campanha1.${dns.domain_name}`,
      `www.campanha2.${dns.domain_name}`,
      `www.campanha3.${dns.domain_name}`
    ]

    it('should open and quit connect redis', async () => {
      await createRouters(routerName, domainNames);

      expect(mockConnect.mock.calls.length).toEqual(1);
      expect(mockQuit.mock.calls.length).toEqual(1);
    });

    it('should register in redis a router with domainNames', async () => {
      await createRouters(routerName, domainNames);

      expect(mockSet.mock.calls[0]).toEqual([`traefik/http/routers/${routerName}-0/tls`, 'true']);
      expect(mockSet.mock.calls[1]).toEqual([`traefik/http/routers/${routerName}-0/tls/certresolver`, 'myresolver']);
      expect(mockSet.mock.calls[2]).toEqual([`traefik/http/routers/${routerName}-0/service`, 'public@docker']);
      expect(mockSet.mock.calls[3]).toEqual([
        `traefik/http/routers/${routerName}-0/rule`,
        `Host(${domainNames.map((domain) => `\`${domain}\``).join(',')})`
      ]);
    });

    it('should register in redis a router every 100 domainNames', async () => {
      const manyDomainNames = Array.from({ length: 150 }, (_, index: number) => `www.campanha${index}.${dns.domain_name}`);

      await createRouters(routerName, manyDomainNames);

      console.log(mockSet.mock.calls);
      expect(mockSet.mock.calls[0]).toEqual([`traefik/http/routers/${routerName}-0/tls`, 'true']);
      expect(mockSet.mock.calls[1]).toEqual([`traefik/http/routers/${routerName}-1/tls`, 'true']);
      
      expect(mockSet.mock.calls[2]).toEqual([`traefik/http/routers/${routerName}-0/tls/certresolver`, 'myresolver']);
      expect(mockSet.mock.calls[3]).toEqual([`traefik/http/routers/${routerName}-1/tls/certresolver`, 'myresolver']);
      
      expect(mockSet.mock.calls[4]).toEqual([`traefik/http/routers/${routerName}-0/service`, 'public@docker']);
      expect(mockSet.mock.calls[5]).toEqual([`traefik/http/routers/${routerName}-1/service`, 'public@docker']);
      
      expect(mockSet.mock.calls[6]).toEqual([
        `traefik/http/routers/${routerName}-0/rule`,
        `Host(${manyDomainNames.slice(0, 100).map((domain) => `\`${domain}\``).join(',')})`
      ]);
      expect(mockSet.mock.calls[7]).toEqual([
        `traefik/http/routers/${routerName}-1/rule`,
        `Host(${manyDomainNames.slice(100, 150).map((domain) => `\`${domain}\``).join(',')})`
      ]);

    });
  })
});