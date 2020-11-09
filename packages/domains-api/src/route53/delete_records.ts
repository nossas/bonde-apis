import config from '../config';
import logger from '../logger';

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

type DNSRecord = {
  name: string
  value: string
  record_type: 'A' | 'MX' | 'CNAME' | 'TXT' | 'AAA'
  ttl: number
}

type Args = {
  hostedZoneId: string
  dnsRecords: DNSRecord[]
}

export default (route53: any) => async ({ dnsRecords, hostedZoneId }: Args) => {
  // Create defaults Record on AWS
  const params: RecordParams = {
    ChangeBatch: {
      Changes: dnsRecords.map((r: DNSRecord) => ({
        Action: 'DELETE',
        ResourceRecordSet: {
          Name: r.name,
          ResourceRecords: [
            { Value: r.value }
          ],
          TTL: r.ttl,
          Type: r.record_type
        }
      })),
      Comment: 'autocreated'
    },
    HostedZoneId: hostedZoneId
  }
  logger.child({ params }).info('changeResourceRecordSets');

  try {
    const result = await route53.changeResourceRecordSets(params).promise();
    logger.child({ result }).info('changeResourceRecordSets');
  } catch (err) {
    logger.child({ err }).info('error');
    return [];
  }
}