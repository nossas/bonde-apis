// import * as recipients from '../graphql-api/recipients';
import express from 'express';
import logger from '../config/logger';
import route53 from '../route53';
import { DNSRecord } from '../route53/types';
import { DNSRecordResult } from '../graphql-api/dns_hosted_zones';

class RecordsController {
  client: any;
  DNSHostedZonesAPI: any;

  constructor(client, DNSHostedZonesAPI) {
    this.client = client;
    this.DNSHostedZonesAPI = DNSHostedZonesAPI;
  }

  createRecords = async (req: express.Request, res: express.Response) => {
    logger.info('In controller - createRecords');
    const { input: { value, name, ttl, record_type, hosted_zone_id, dns_hosted_zone_id } } = req.body;

    try {
      const records = await route53.create_record({ value, name, ttl, record_type, hosted_zone_id });
      const objects = [{ value, name, ttl, record_type }].map((r: DNSRecord) => ({
        ...r,
        name: r.name.replace('\\052', '*'),
        dns_hosted_zone_id: dns_hosted_zone_id
      }))
      await this.DNSHostedZonesAPI.records_upsert(objects, this.client);

      logger.child({ objects, records }).info('create_record');
      res.json({ objects, records });
    } catch (err) {
      logger.child({ err }).info('create_record');
      res.status(500).json(err);
    }
  };

  deleteRecords = async (req, res) => {
    logger.info('In controller - deleteRecords');
    const { input: { dns_hosted_zone_id, records } } = req.body;

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
      res.json({ status: 'ok' });
    } catch (err) {
      logger.child({ err }).info('delete_hosted_zone');
      res.status(500).json(err);
    }
  };
}

export default RecordsController;
