import etcdClient from './client';

export const createWildcard = async (routerName: string, domainName: string): Promise<void> => {
  // Configure routers
  await etcdClient.put(`traefik/http/routers/${routerName}/tls`).value('true');
  await etcdClient.put(`traefik/http/routers/${routerName}/tls/certresolver`).value('myresolver');
  await etcdClient.put(`traefik/http/routers/${routerName}/rule`).value(`HostRegexp(\`${domainName}\`, \`{subdomain:.+}.${domainName}\`)`);
  await etcdClient.put(`traefik/http/routers/${routerName}/tls/domains/0/main`).value(domainName);
  await etcdClient.put(`traefik/http/routers/${routerName}/tls/domains/0/sans/0`).value(`*.${domainName}`);
  await etcdClient.put(`traefik/http/routers/${routerName}/service`).value('public@docker');
}

export const createRouters = async (routerName: string, domainNames: string[]): Promise<void> => {
  // Configure routers
  let cursor = Math.floor(domainNames.length / 100);
  if (domainNames.length % 100 !== 0) cursor += 1;
  

  await Promise.all(Array.from({ length: cursor > 0 ? cursor : 1 }, async (_, index: number) => {
    await etcdClient.put(`traefik/http/routers/${routerName}-${index}/tls`).value('true');
    await etcdClient.put(`traefik/http/routers/${routerName}-${index}/tls/certresolver`).value('myresolver');
    await etcdClient.put(`traefik/http/routers/${routerName}-${index}/service`).value('public@docker');
    await etcdClient
      .put(`traefik/http/routers/${routerName}-${index}/rule`)
      .value(
        `Host(${domainNames.slice(index * 100, (index + 1) * 100).map((domain) => `\`${domain}\``).join(',')})`
      );
  }))
}