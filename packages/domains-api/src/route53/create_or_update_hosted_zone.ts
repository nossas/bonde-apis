import logger from '../config/logger';
import { HostedZone, DelegationSet } from './types';

type Args = {
  domain: string
  comment: string
}

type Result = {
  HostedZone: HostedZone
  DelegationSet: DelegationSet
}

const get_hosted_zone = async ({ route53, result, domain }: any) => {
  // Get Hosted Zone if exists
  const filtered = result.HostedZones.filter((hz: any) => hz.Name.replace(/\.$/, '') === domain);
  logger.child({ filtered, domain }).info('get_hosted_zone');
  if (filtered.length === 0 && result.IsTruncated) {
    return await get_hosted_zone({
      route53,
      domain,
      result: await route53.listHostedZones({ Marker: result.NextMarker }).promise()
    });
  }

  return filtered[0];
}

export default (route53: any) => async ({ domain, comment }: Args): Promise<Result> => {
  // Get Hosted Zone if exists
  const result = await route53.listHostedZones().promise();
  const hostedZone = await get_hosted_zone({ route53, result, domain });

  if (hostedZone) {
    const data: Result = await route53.getHostedZone({ Id: hostedZone.Id }).promise();
    return data;
  }

  // Create Hosted Zone on AWS
  const params: HostedZone = {
    CallerReference: `${new Date().toISOString()}-${Math.random()}`,
    Name: domain,
    HostedZoneConfig: {
      Comment: comment,
      PrivateZone: false
    }
  }

  return await route53.createHostedZone(params).promise();
}