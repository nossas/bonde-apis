import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import depthLimit from 'graphql-depth-limit';
import { createServer } from 'http';
import compression from 'compression';
import cors from 'cors';
import expressPino from 'express-pino-logger';
import jwt from 'jsonwebtoken';
import config from './config';
import schema from './schema';
import logger from './logger';

const app = express();

const expressLogger = expressPino({ logger });

if (!config.jwtSecret) throw new Error('No JWT_SECRET provided.');

const server = new ApolloServer({
  schema: schema,
  validationRules: [depthLimit(7)],
  context: ({ req }: any) => {
    const { headers: { authorization } } = req;
    // const token = authorization.replace('Bearer ', '');
    // logger.child({ jwtSecret: config.jwtSecret, token: authorization }).info('context');
  
    if (!!authorization) {
      let session: any;
      
      jwt.verify(authorization.replace('Bearer ', ''), config.jwtSecret || '', (err: any, decoded: any) => {
        logger.info('jwt verify');
        if (decoded) {
          session = decoded;
        } else {
          logger.child({ err }).error('context');
        }
      });

      return { session };
    }
    return {};
  }
} as any);


type Headers = {
  authorization?: string
}

type Request = {
  headers: Headers
}

// const verifyToken = () => (req: any, res: any, next: any) => {
//   logger.child({ req }).info('req');
//   const { headers: { authorization } }: Request = req;

//   if (!config.jwtSecret) return res.status(500).json({ auth: false, message: 'No secret provided.' });
//   if (!authorization) return res.status(500).json({ auth: false, message: 'No token provided.' });

//   jwt.verify(authorization.replace('Bearer ', ''), config.jwtSecret, (err: any, decoded: any) => {
//     if (err) return res.status(500).json({ auth: false, message: 'Failed to authenticate token.' });
    
//     req.decoded = decoded;
    
//     next();
//   })

//   // next();
// }

// const verityPermission = () => (req: any, res: any, next: any) => {
//   const { decoded } = req;

//   logger.child({ decoded }).info('verityPermission');

//   next();
// }

app.use('*', cors());
app.use(compression());
app.use(expressLogger);

server.applyMiddleware({ app, path: '/graphql' });

const httpServer = createServer(app);

httpServer.listen(
  { host: config.host, port: config.port },
  () => logger.info(`GraphQL is now running on http://${config.host}:${config.port}/graphql`)
);

