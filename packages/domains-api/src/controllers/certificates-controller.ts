import logger from '../config/logger';

class CertificatesController {
  createCertificate = async (req, res) => {
    logger.info('In controller - createCertificate');
    res.json({ ok: true })
  }
  checkCertificate = async (req, res) => {
    logger.info('In controller - checkCertificate');
    res.json({ ok: true })
  }
  checkPage = async (req, res) => {
    logger.info('In controller - checkPage');
    res.json({ ok: true })
  }
}

export default CertificatesController;