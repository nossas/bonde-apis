import logger from '../config/logger';
import route53 from '../route53';
import { DNSRecordResult } from '../graphql-api/dns_hosted_zones';
import { HasuraActionRequest } from '../types';

interface InputDeleteRecords {
  records: {
    dns_hosted_zone_id: number;
    records: number[];
    community_id: number;
  }
}

interface InputRecord {
  record: {
    name: string;
    value: string[] | string;
    ttl: number
    record_type: string;
    hosted_zone_id: number;
    dns_hosted_zone_id: number;
    community_id: number;
  }
}


class RecordsController {
  client: any;
  DNSHostedZonesAPI: any;

  constructor(DNSHostedZonesAPI, client) {
    this.client = client;
    this.DNSHostedZonesAPI = DNSHostedZonesAPI;
  }

  createRecords = async (req: HasuraActionRequest<InputRecord>, res) => {
    logger.info('In controller - createRecords');
    const { record: { value, name, ttl, record_type, hosted_zone_id, dns_hosted_zone_id } } = req.body.input;

    try {
      await route53.create_record({ value, name, ttl, record_type, hosted_zone_id });
      const record = {
        value,
        ttl,
        record_type,
        name: name.replace('\\052', '*'),
        dns_hosted_zone_id: dns_hosted_zone_id
      }
      await this.DNSHostedZonesAPI.records_upsert([record], this.client);

      logger.child({ record }).info('create_record');
      res.json(record);
    } catch (err: any) {
      logger.child({ err }).info('create_record');
      res.status(400).json({
        message: err.message,
        extensions: err
      });
    }
  };

  deleteRecords = async (
    req: HasuraActionRequest<InputDeleteRecords>,
    res
  ) => {
    logger.info('In controller - deleteRecords');
    const {
      input: {
        records: { dns_hosted_zone_id, records }
      }
    } = req.body;

    try {
      const dnsHostedZone = await this.DNSHostedZonesAPI.get(dns_hosted_zone_id, this.client);
      const hostedZoneId = dnsHostedZone.hosted_zone.Id || dnsHostedZone.hosted_zone.id;

      logger.child({ dnsHostedZone }).info('delete_hosted_zone');

      const delete_records: DNSRecordResult[] | undefined = dnsHostedZone.dns_records?.filter(
        (dr: any) => !!records.find((r: any) => r === dr.id));

      await route53.delete_records({
        hostedZoneId,
        dnsRecords: delete_records?.map((dr: DNSRecordResult) => {
          const dnsRecord = {
            record_type: dr.record_type,
            value: dr.value,
            name: dr.name.replace(/(\.)$/, ''),
            ttl: dr.ttl
          };

          logger.child({ dnsRecord }).info('delete_records');
          return dnsRecord;
        })
      });

      await this.DNSHostedZonesAPI.remove_records(records, this.client);
      res.json({ dns_hosted_zone_id, records });
    } catch (err: any) {
      logger.child({ err }).info('delete_hosted_zone');
      res.status(400).json({
        message: err.message,
        extensions: err
      });
    }
  };
}

export default RecordsController;
