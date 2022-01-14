import jwt from 'jsonwebtoken';

type Options = {
  jwtSecret?: string
  logger?: any
}

type Headers = {
  authorization?: string
}

type Request = {
  headers: Headers
}

type ExpressOpts = {
  req: Request
  res: any
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const handle_context = ({ jwtSecret, logger }: Options) => ({ req, res }: ExpressOpts) => {
  const { headers: { authorization } } = req;

  if (!!authorization) {
    let session: any;

    jwt.verify(authorization.replace('Bearer ', ''), jwtSecret || '', (err: any, decoded: any) => {
      logger?.info('jwt verify');
      if (decoded) {
        session = decoded;
      } else {
        logger?.child({ err }).error('context');
      }
    });

    return { session, req, res };
  }
  return { req, res };
}

