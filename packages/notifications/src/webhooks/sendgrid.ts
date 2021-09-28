import {
  EventWebhook,
  EventWebhookHeader
} from "@sendgrid/eventwebhook";
import { Request } from "express";
import config from "../config";
import logger, { apmAgent } from "../logger";
import { client } from "../core/elasticsearchdb";

if (!config.sendgridWebhookKey) {
  const error = new Error("SENDGRID_WEBHOOK_KEY should be environment");
  apmAgent?.captureError(error);
  logger.error(error);
}

const verifyRequest = (
  publicKey: string,
  payload: string,
  signature: any,
  timestamp: any
): any => {
  const eventWebhook = new EventWebhook();
  const ecPublicKey = eventWebhook.convertPublicKeyToECDSA(publicKey);
  return eventWebhook.verifySignature(ecPublicKey, payload, signature, timestamp);
}

type Event = {
  email: string
  timestamp: number
  event: string
  category: string
  sg_event_id: string
  sg_message_id: string
  "smtp-id": string
}

const _document_sendgrid = (events: Event[], status: string) => {
  events.forEach((event) => {
    const date = new Date(event.timestamp * 1000);
    const humanMonth = date.getMonth() + 1;
    const month = humanMonth > 9 ? humanMonth : "0" + humanMonth;
    const { "smtp-id": smtp_id, ...body } = event;
    const index = `events-sendgrid-${date.getFullYear()}.${month}`;
    const eventIndexable = {
      index,
      method: "PUT",
      id: event.sg_event_id,
      body: {
        smtp_id,
        status,
        ...body
      }
    }

    client.index(eventIndexable);
    logger.child({ event: eventIndexable }).info(`event index ${index} on elasticsearch`);
  });
}

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export default async (req: Request<any, any, Event[]>, res: any): Promise<void> => {
  try {
    const key: string = config.sendgridWebhookKey || '';
    const signature = req.get(EventWebhookHeader.SIGNATURE());
    const timestamp = req.get(EventWebhookHeader.TIMESTAMP());

    if (!signature && !timestamp) throw new Error("signature and timestamp is empty");

    if (verifyRequest(key, JSON.stringify(req.body) + '\r\n', signature, timestamp)) {
      _document_sendgrid(req.body, "verified");
      return res.sendStatus(204);
    }
    // Create index when not verifyRequest
    _document_sendgrid(req.body, "invalid");
    return res.sendStatus(204);
  } catch (error) {
    apmAgent?.captureError(error);
    logger.error(error as any);
    return res.status(500).send(error);
  }
}