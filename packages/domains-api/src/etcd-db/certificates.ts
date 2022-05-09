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

export const getRouters = async (id: number, domain: string) => {
  const routerName = `${id}-${domain.replace('.', '-')}`;

  const value = await etcdClient.get(`traefik/http/routers/${routerName}/tls/domains/0/main`).string();
  
  if (!value) throw new Error('wildcard_not_found');

  const values: any = await etcdClient.getAll().prefix(`traefik/http/routers/${routerName}-www`).strings();
  
  const res: any = [];
  for (let i = 0; i < values.length; i += 8) {
    const chunk: string[] = values.slice(i, i + 8);
    res.push(chunk);
  }

  const routers: any[] = []
  res.forEach(element => {
    const elementSplit = element[1].split(',').map((host) => host.match(/`(.+)`/gi)).map(
      el => el[0].replaceAll('`', '')
    );
    
    routers.push(...elementSplit);
  });

  return routers;
}