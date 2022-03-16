// import dependencies and initialize the express router
import express from 'express';
import swaggerUi from 'swagger-ui-express';
import swaggerDoc from '../config/swagger.json'

const router = express.Router();

// define routes
router.use('/api-docs', swaggerUi.serve);
router.get('/api-docs', swaggerUi.setup(swaggerDoc));

export default router;