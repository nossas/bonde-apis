import app from './app'
import logger from '../config/logger'

// start node server
const port = process.env.PORT || 3000;
// await new Promise<void>(resolve => httpServer.listen({ port: 4000 }, resolve));
app.listen(port, () => {
  logger.info(`App UI available http://localhost:${port}`);
  logger.info(`Swagger UI available http://localhost:${port}/swagger/api-docs`);
  logger.info(`Events available http://localhost:${port}/events`);
  logger.info(`Actions available http://localhost:${port}/actions`);
});
