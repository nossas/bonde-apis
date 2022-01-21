import jwt from 'jsonwebtoken';

type Options = {
  jwtSecret?: string
  logger?: any
}

type Request = {
  headers: any
}

type ExpressOpts = {
  req: Request
  res: any
}

const getCookie = (keyName: string, req: any): string | undefined => {
  try {
    const pattern = `${keyName}=`;
    const cookie = req.headers.cookie?.split('; ').filter((value: string) => value.startsWith(pattern))[0];
    return cookie?.replace(pattern, '').trim();
  } catch (err) {
    console.log('getCookie error: ', err);
  }
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const handle_context = ({ jwtSecret, logger }: Options) => ({ req, res }: ExpressOpts) => {
  const authorization = getCookie('session', req);
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

