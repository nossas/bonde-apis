import pino from 'pino';
import config from './config';

const logger = pino({ level: config.logLevel || 'info' });

export default logger;