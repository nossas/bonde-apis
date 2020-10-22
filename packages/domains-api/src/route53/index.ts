import AWS from 'aws-sdk';
import config from '../config';
import create_or_update_hosted_zone from './create_or_update_hosted_zone';
import create_default_records from './create_default_records';

if (!config.awsAccessKey) throw new Error('AWS_ACCESS_KEY not found');
if (!config.awsSecretKey) throw new Error('AWS_SECRET_KEY not found');

if (!config.awsRouteIp) throw new Error('AWS_ROUTE_IP not found');

// Configure AWS
AWS.config.update({
  accessKeyId: config.awsAccessKey,
  secretAccessKey: config.awsSecretKey,
  region: config.awsRoute53Region
})

const handle_route53 = (callback: any) => callback(new AWS.Route53());

export default {
  create_default_records: handle_route53(create_default_records),
  create_or_update_hosted_zone: handle_route53(create_or_update_hosted_zone)
}