import logger from '../config/logger';
import { gql } from '../graphql-api/client';
import { validationResult } from 'express-validator';

const insert_certificate = gql`
mutation ($input: certificates_insert_input!) {
  insert_certificates_one(object:$input,

    ) {
    id
    dns_hosted_zone_id
    is_active
    community_id
  }
}
`;

class CertificatesController {
  redisClient: any
  graphqlClient: any

  constructor(redisClient, graphqlClient) {
    this.redisClient = redisClient;
    this.graphqlClient = graphqlClient;
  }

  createCertificate = async (req, res) => {

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    await this.insertCertificateRedis(req.body.payload.event.data.new);
    res.json(await this.insertCertificateGraphql(req.body.payload.event.data.new));
  }

  insertCertificateRedis = async (input: any) => {
    const { domain_name, id } = input;
    const tRouterName = `${id}-${domain_name.replace('.', '-')}`
    logger.info(`In controller - createCertificate ${tRouterName}`);

    await this.redisClient.connect();
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls`, 'true');
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/certresolver`, 'myresolver');
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/rule`, `HostRegexp(\`${domain_name}\`, \`{subdomain:.+}.${domain_name}\`)`);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/domains/0/main`, domain_name);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/tls/domains/0/sans/0`, `*.${domain_name}`);
    await this.redisClient.set(`traefik/http/routers/${tRouterName}/service`, 'public@docker');
    // console.log(await this.redisClient.get('traefik'));
    await this.redisClient.quit();
  }

  insertCertificateGraphql = async (input: any) => {
    const { data, errors }: any = await this.graphqlClient.request({
      document: insert_certificate,
      variables: { input }
    });

    logger.child({ errors, data }).info('insert_certificate.upsert');

    return data.insert_certificates_one;
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