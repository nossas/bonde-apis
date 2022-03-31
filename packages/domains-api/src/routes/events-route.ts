// import dependencies and initialize the express router
import express from 'express';
import CertificatesController from '../controllers/certificates-controller';
// import redisClient from '../redis-db/client'
import { client } from '../graphql-api/client';

const router = express.Router();

const certificatesController = new CertificatesController(client);

// define routes
router.post('/create-certificate', certificatesController.create);
router.post('/check-certificate', certificatesController.check);

export default router;