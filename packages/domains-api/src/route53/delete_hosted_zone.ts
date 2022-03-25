import logger from '../config/logger';

export default (route53: any) => async ({ hostedZoneId }: any): Promise<void> => {
  const result = await route53.deleteHostedZone({ Id: hostedZoneId });
  logger.child({ result }).info('delete_hosted_zone');
}