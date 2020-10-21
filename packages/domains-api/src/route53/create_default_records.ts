import config from '../config';
import logger from '../logger';

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
  HostedZoneId: string
}

type Args = {
  domain: string
  hostedZoneId: string
}

export default (route53: any) => async ({ domain, hostedZoneId }: Args) => {
  // Create defaults Record on AWS
  const records: RecordParams = {
    ChangeBatch: {
      Changes: [
        {
          Action: 'CREATE',
          ResourceRecordSet: {
            Name: domain,
            ResourceRecords: [
              { Value: config.awsRouteIp }
            ],
            TTL: 300,
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
            TTL: 300,
            Type: 'A'
          }
        }
      ],
      Comment: 'autocreated'
    },
    HostedZoneId: hostedZoneId
  }
  logger.child({ records }).info('changeResourceRecordSets');

  try {
    const result = await route53.changeResourceRecordSets(records).promise();
    logger.child({ result }).info('changeResourceRecordSets');
  } catch (err) {
    logger.child({ err }).info('error');
  }
}