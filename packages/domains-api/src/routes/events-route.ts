// import dependencies and initialize the express router
import express from 'express';
import CertificatesController from '../controllers/certificates-controller';

const router = express.Router();

const certificatesController = new CertificatesController();

// define routes
router.post('/create_certificate', certificatesController.createCertificate);

export default router;