import config from '../config';
import logger from '../logger';
import * as DNSHostedZones from '../graphql-api/dns_hosted_zones';

type ResourceRecord = {
  Value: string
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
  name: string
  value: string | string[]
  ttl: number
  record_type: string
  hosted_zone_id: string
}

export default (route53: any) => async ({ name, value, ttl, record_type, hosted_zone_id }: Args) => {
  // Create defaults Record on AWS
  const records: RecordParams = {
    ChangeBatch: {
      Changes: [
        {
          Action: 'CREATE',
          ResourceRecordSet: {
            Name: name,
            ResourceRecords: typeof value === 'string'
              ? [ { Value: value } ]
              : value.map((v: string) => ({ Value: v })),
            TTL: ttl,
            Type: record_type
          }
        }
      ],
      Comment: 'autocreated'
    },
    HostedZoneId: hosted_zone_id
  }

  logger.child({ records }).info('changeResourceRecordSets');

  try {
    const result = await route53.changeResourceRecordSets(records).promise();
    logger.child({ result }).info('changeResourceRecordSets');
  } catch (err) {
    logger.child({ err }).info('error');
    return [];
  }
}