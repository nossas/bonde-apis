// import { ApolloServer } from 'apollo-server-express';
// import { ApolloServerPluginDrainHttpServer } from 'apollo-server-core';
import expressPino from 'express-pino-logger';
// import http from 'http';
import express from 'express';
import path from 'path';
import bodyParser from 'body-parser';
import helmet from 'helmet';
// import depthLimit from 'graphql-depth-limit';
// import config from '../config/config';

import logger from '../config/logger';
// import { handle_context } from 'permissions-utils';
import healthRoutes from '../routes/health-route';
import swaggerRoutes from '../routes/swagger-route';
import actionsRoutes from '../routes/actions-route';
import eventsRoutes from '../routes/events-route';

const app = express();

const expressLogger = expressPino({ logger });
app.use(expressLogger);

// if production, enable helmet
/* c8 ignore next 3  */
if (process.env.NODE_ENV) {
    app.use(helmet());
}

// enable parsing of http request body
app.use(bodyParser.urlencoded());
app.use(bodyParser.json());

// routes and api calls
app.use('/health', healthRoutes);
app.use('/swagger', swaggerRoutes);
app.use('/actions', actionsRoutes);
app.use('/events', eventsRoutes);

// async () => {
//   if (!config.jwtSecret) throw new Error('No JWT_SECRET provided.');
//   const httpServer = http.createServer(app);
//   const graphqlServer = new ApolloServer({
//     schema: schema,
//     validationRules: [depthLimit(7)],
//     context: handle_context({ jwtSecret: config.jwtSecret, logger }),
//     plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
//   });

//   await graphqlServer.start();
//   graphqlServer.applyMiddleware({ app, path: '/graphql' });
// }
// await new Promise<void>(resolve => httpServer.listen({ port: 4000 }, resolve));

// default path to serve up index.html (single page application)
app.all('', (req, res) => {
    res.status(200).sendFile(path.join(__dirname, '../public', 'index.html'));
});

// error handler for unmatched routes or api calls
app.use((req, res, next) => {
    res.sendFile(path.join(__dirname, '../public', '404.html'));
});

export default app;