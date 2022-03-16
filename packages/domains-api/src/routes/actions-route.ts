// import dependencies and initialize the express router
import express from 'express';
import RecordsController from '../controllers/records-controller';
import DomainsController from '../controllers/domains-controller';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';
import { client } from '../graphql-api/client';

const router = express.Router();

const recordsController = new RecordsController(DNSHostedZonesAPI, client);
const domainsController = new DomainsController(DNSHostedZonesAPI, client);

// define routes
router.post('/create_domains', domainsController.createDomains);
router.post('/delete_domains', domainsController.deleteDomains);
router.post('/create_records', recordsController.createRecords);
router.post('/delete_records', recordsController.deleteRecords);

export default router;
