import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import depthLimit from 'graphql-depth-limit';
import { createServer } from 'http';
import compression from 'compression';
import cors from 'cors';
import expressPino from 'express-pino-logger';
import schema from './schema';
import logger from './logger';
import config from './config';
import { handle_context } from 'permissions-utils';

if (!config.jwtSecret) throw new Error('No JWT_SECRET provided.');

const app = express();
const server = new ApolloServer({
  schema: schema,
  validationRules: [depthLimit(7)],
  context: handle_context({ jwtSecret: config.jwtSecret, logger })
} as any);
const expressLogger = expressPino({ logger });

app.use('*', cors() as any);
app.use(compression());
app.use(expressLogger);

server.applyMiddleware({ app, path: '/graphql' });

const httpServer = createServer(app);

httpServer.listen(
  { host: config.host, port: config.port },
  () => logger.info(`GraphQL is now running on http://${config.host}:${config.port}/graphql`)
);

