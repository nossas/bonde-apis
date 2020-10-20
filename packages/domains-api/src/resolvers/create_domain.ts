// import * as recipients from '../graphql-api/recipients';
import AWS from 'aws-sdk';
import logger from '../logger';
import config from '../config';
import { check_user, Roles } from '../permissions';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';

if (!config.awsAccessKey) throw new Error('AWS_ACCESS_KEY not found');
if (!config.awsSecretKey) throw new Error('AWS_SECRET_KEY not found');
if (!config.awsRouteIp) throw new Error('AWS_ROUTE_IP not found');

// Configure AWS
AWS.config.update({
  accessKeyId: config.awsAccessKey,
  secretAccessKey: config.awsSecretKey,
  region: config.awsRoute53Region
})

type DomainInput = {
  domain: string
  comment?: string
  community_id: number
}

type Args = {
  input: DomainInput
}

type HostedZoneConfig = {
  Comment?: string
  PrivateZone: boolean
}

type HostedZoneParams = {
  CallerReference: string
  Name: string
  DelegationSetId?: string
  HostedZoneConfig: HostedZoneConfig
}

type ResourceRecord = {
  Value?: string
}

type ResourceRecordSet = {
  Name: string
  ResourceRecords: ResourceRecord[]
  TTL: number
  Type: string
}

type Change = {
  Action: string
  ResourceRecordSet: ResourceRecordSet
}

type ChangeBatch = {
  Changes: Change[]
  Comment: string
}

type RecordParams = {
  ChangeBatch: ChangeBatch
  HostedZonedId: string
}

// Resolver create domain
const create_domain = async (_: void, args: Args): Promise<DNSHostedZonesAPI.DNSHostedZoneResult> => {
  const { input: { domain, comment, community_id } } = args;
  const route53 = new AWS.Route53();

  // Create Hosted Zone on AWS
  const params: HostedZoneParams = {
    CallerReference: `${new Date().toISOString()}-${Math.random()}`,
    Name: domain,
    HostedZoneConfig: {
      Comment: comment,
      PrivateZone: false
    }
  }
  const data = await route53.createHostedZone(params).promise();
  logger.child({ data }).info('createHostedZone');

  const dnsHostedZone = await DNSHostedZonesAPI.insert({
    domain_name: domain,
    comment: comment,
    community_id: community_id,
    response: data
  })
  logger.child({ dnsHostedZone }).info('createHostedZone');
  
  // Create defaults Record on AWS
  const records: any = {
    ChangeBatch: {
      Changes: [
        {
          Action: 'CREATE',
          ResourceRecordSet: {
            Name: domain,
            ResourceRecords: [
              { Value: config.awsRouteIp }
            ],
            TTL: 60,
            Type: 'A'
          }
        },
        {
          Action: 'CREATE',
          ResourceRecordSet: {
            Name: `*.${domain}`,
            ResourceRecords: [
              { Value: config.awsRouteIp }
            ],
            TTL: 60,
            Type: 'A'
          }
        }
      ],
      Comment: 'autocreated'
    },
    HostedZoneId: data.HostedZone.Id
  }
  logger.child({ records }).info('changeResourceRecordSets');

  try {
    const result = await route53.changeResourceRecordSets(records).promise();
    logger.child({ result }).info('changeResourceRecordSets');
  } catch (err) {
    logger.child({ err }).info('error');
  }

  return dnsHostedZone;
}

export default check_user(create_domain, Roles.ADMIN);