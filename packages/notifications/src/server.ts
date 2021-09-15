import express from 'express';
import bodyParser from 'body-parser';
import { createServer } from 'http';
import compression from 'compression';
import cors from 'cors';
import expressPino from 'express-pino-logger';
import config from './config';
import { webhooks } from './webhooks';
import { graphql } from './graphql-api';
import logger from './logger';

const app = express();

const expressLogger = expressPino({ logger });

app.use('*', cors() as any);
app.use(bodyParser.json({ limit: '50mb' }));
app.use(compression());
app.use(expressLogger);

// Makes webhooks available on express
webhooks.applyMiddleware({ app, path: '/webhooks' });

// Makes remote schema available on express
graphql.applyMiddleware({ app, path: '/graphql' });

const httpServer = createServer(app);

httpServer.listen(
  { host: config.host, port: config.port },
  () => {
    logger.info(`API is now running on http://${config.host}:${config.port}/graphql`);
    logger.info(`Webhooks is now running on http://${config.host}:${config.port}/webhooks`);
  }
);