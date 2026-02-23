import config from '../config/config';
import logger from '../config/logger';

type AliasTarget = {
  DNSName: string;
  EvaluateTargetHealth: boolean;
  HostedZoneId: string;
};

type ResourceRecord = {
  Value: string;
};

type ResourceRecordSet = {
  Name: string;
  ResourceRecords?: ResourceRecord[];
  AliasTarget?: AliasTarget;
  TTL?: number;
  Type: string;
};

type Change = {
  Action: string;
  ResourceRecordSet: ResourceRecordSet;
};

type ChangeBatch = {
  Changes: Change[];
  Comment: string;
};

type RecordParams = {
  ChangeBatch: ChangeBatch;
  HostedZoneId: string;
};

type Args = {
  domain: string;
  hostedZoneId: string;
};

export default (route53: any) => async ({ domain, hostedZoneId }: Args) => {
  const records: RecordParams = {
    ChangeBatch: {
      Changes: [
        {
          Action: 'CREATE',
          ResourceRecordSet: {
            Name: domain,
            Type: 'A',
            AliasTarget: {
              DNSName: config.awsLoadBalancerDns,
              EvaluateTargetHealth: true,
              HostedZoneId: config.awsLoadBalancerHostedZoneId
            }
          }
        },
        {
          Action: 'CREATE',
          ResourceRecordSet: {
            Name: `*.${domain}`, 
            ResourceRecords: [
              { Value: config.awsLoadBalancerDns }
            ],
            TTL: 300,
            Type: 'CNAME'
          }
        }
      ],
      Comment: 'autocreated'
    },
    HostedZoneId: hostedZoneId
  };

  logger.child({ records }).info('changeResourceRecordSets');
  
  try {
    const result = await route53.changeResourceRecordSets(records).promise();
    logger.child({ result }).info('changeResourceRecordSets - success');
    return result;
  } catch (err) {
    logger.child({ err }).error('changeResourceRecordSets - error');
    throw err;
  }
};