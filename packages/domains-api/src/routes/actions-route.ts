// import dependencies and initialize the express router
import express from 'express';
import { oneOf, check } from 'express-validator';
import RecordsController from '../controllers/records-controller';
import DomainsController from '../controllers/domains-controller';
import CertificatesController from '../controllers/certificates-controller';
import * as DNSHostedZonesAPI from '../graphql-api/dns_hosted_zones';
import { client } from '../graphql-api/client';
import redisClient from '../redis-db/client'

const router = express.Router();

const recordsController = new RecordsController(DNSHostedZonesAPI, client);
const domainsController = new DomainsController(DNSHostedZonesAPI, client);
const certificatesController = new CertificatesController(redisClient, client);

// define routes
router.post('/create_domain', domainsController.createDomains);
router.post('/delete_domain', domainsController.deleteDomains);
router.post('/create_record', recordsController.createRecords);
router.post('/delete_record', recordsController.deleteRecords);
router.post('/check_certificate', oneOf([
    check('payload').exists()
]), certificatesController.checkCertificate);
router.post('/check_page', certificatesController.checkPage);
export default router;
