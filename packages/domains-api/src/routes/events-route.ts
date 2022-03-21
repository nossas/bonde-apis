// import dependencies and initialize the express router
import express from 'express';
import CertificatesController from '../controllers/certificates-controller';
import redisClient from '../redis-db/client'
import { client } from '../graphql-api/client';

const router = express.Router();

const certificatesController = new CertificatesController(redisClient, client);

// define routes
router.post('/create_certificate', certificatesController.createCertificate);

export default router;