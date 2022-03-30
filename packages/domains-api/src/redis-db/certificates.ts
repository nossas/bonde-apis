import redisClient from './client';

export const createWildcard = async (routerName: string, domainName: string): Promise<void> => {
  // Open connection with redis
  await redisClient.connect();
  // Configure routers
  await redisClient.set(`traefik/http/routers/${routerName}/tls`, 'true');
  await redisClient.set(`traefik/http/routers/${routerName}/tls/certresolver`, 'myresolver');
  await redisClient.set(`traefik/http/routers/${routerName}/rule`, `HostRegexp(\`${domainName}\`, \`{subdomain:.+}.${domainName}\`)`);
  await redisClient.set(`traefik/http/routers/${routerName}/tls/domains/0/main`, domainName);
  await redisClient.set(`traefik/http/routers/${routerName}/tls/domains/0/sans/0`, `*.${domainName}`);
  await redisClient.set(`traefik/http/routers/${routerName}/service`, 'public@docker');
  // Close connection with redis
  await redisClient.quit();
}

export const createRouters = async (routerName: string, domainNames: string[]): Promise<void> => {
  // Open connection with redis
  await redisClient.connect();
  // Configure routers
  let cursor = Math.floor(domainNames.length / 100);
  if (domainNames.length % 100 !== 0) cursor += 1;
  

  await Promise.all(Array.from({ length: cursor > 0 ? cursor : 1 }, async (_, index: number) => {
    await redisClient.set(`traefik/http/routers/${routerName}-${index}/tls`, 'true');
    await redisClient.set(`traefik/http/routers/${routerName}-${index}/tls/certresolver`, 'myresolver');
    await redisClient.set(`traefik/http/routers/${routerName}-${index}/service`, 'public@docker');
    await redisClient.set(
      `traefik/http/routers/${routerName}-${index}/rule`,
      `Host(${domainNames.slice(index * 100, (index + 1) * 100).map((domain) => `\`${domain}\``).join(',')})`
    );
  }))

  // Close connection with redis
  await redisClient.quit();
}