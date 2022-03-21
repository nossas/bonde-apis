import logger from '../config/logger';

class CertificatesController {
  redisClient: any

  constructor(redisClient) {
    this.redisClient = redisClient;
  }

  createCertificate = async (req, res) => {

    const { domain_name, id } = req.body.payload.event.data.new;
    const tRouterName = `${id}-${domain_name.replace('.', '-')}`
    logger.info(`In controller - createCertificate ${tRouterName}`);
    await this.redisClient.connect();
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls`, 'false');
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/certresolver`, 'myresolver');
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/rule`, `HostRegexp(\`${domain_name}\`, \`{subdomain:.+}.${domain_name}\`)`);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/domains/0/main`, domain_name);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/domains/0/sans/0`, `*.${domain_name}`);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/service`, 'public@docker');

    console.log(await this.redisClient.get('traefik'));
    await this.redisClient.quit();
    res.json(req.body)
  }
  checkCertificate = async (req, res) => {
    logger.info('In controller - checkCertificate');
    res.json({ ok: true })
  }
  checkPage = async (req, res) => {
    logger.info('In controller - checkPage');
    res.json({ ok: true })
  }
}

export default CertificatesController;