import logger from '../config/logger';
import { DNSRecord } from './types';

type ResourceRecord = {
  Value: string
}

type ResourceRecordSet = {
  Name: string
  Type: string
  TTL: number
  ResourceRecords: ResourceRecord[]
}

type Result = {
  ResourceRecordSets: ResourceRecordSet[]
}

export default (route53: any) => async ({ hostedZoneId }: any): Promise<DNSRecord[]> => {
  const params = { HostedZoneId: hostedZoneId };
  try {
    const result: Result = await route53.listResourceRecordSets(params).promise();
    logger.child({ result }).info('fetch_records');

    const records = result.ResourceRecordSets.map((r: ResourceRecordSet) => ({
      name: r.Name.slice(0, -1),
      record_type: r.Type,
      ttl: r.TTL,
      value: (r.Type === 'NS' || r.Type === 'MX')
        ? r.ResourceRecords.map((rr: ResourceRecord) => rr.Value).join(' ')
        : r.ResourceRecords[0].Value
    }));

    logger.child({ records }).info('fetch_records');
    return records;
  } catch (err) {
    logger.child({ err }).info('fetch_records');
    return [];
  }
}