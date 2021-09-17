import pino from 'pino';
import apm from "elastic-apm-node";
import ecsFormat from "@elastic/ecs-pino-format";
import config from './config';

// const logger = pino({ level: config.logLevel || 'info' });
const logger = pino({ ...ecsFormat({ convertReqRes: true }) })

const { apmSecretToken, apmServerUrl, apmServiceName } = config;

export let apmAgent;

if (apmSecretToken && apmServerUrl && apmServiceName) {
  apmAgent = apm.start({
    secretToken: apmSecretToken,
    serverUrl: apmServerUrl,
    serviceName: apmServiceName,
    environment: process.env.NODE_ENV,
    captureBody: "errors"
  });
}

export default logger;
