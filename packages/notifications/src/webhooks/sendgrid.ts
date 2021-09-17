import {
  EventWebhook,
  EventWebhookHeader
} from "@sendgrid/eventwebhook";
import { Request } from "express";
import config from "../config";
import logger from "../logger";
import { client } from "./elasticsearchdb";

if (!config.sendgridWebhookKey) throw new Error("SENDGRID_WEBHOOK_KEY should be environment");

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

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export default async (req: Request<any, any, Event[]>, res: any): Promise<void> => {
  try {
    const key: string = config.sendgridWebhookKey || '';
    const signature = req.get(EventWebhookHeader.SIGNATURE());
    const timestamp = req.get(EventWebhookHeader.TIMESTAMP());

    if (verifyRequest(key, JSON.stringify(req.body) + '\r\n', signature, timestamp)) {
      req.body.forEach((event) => {
        const date = new Date(event.timestamp * 1000);
        const month = date.getMonth() > 9 ? date.getMonth() : "0" + date.getMonth();
        const { "smtp-id": smtp_id, ...body } = event;
        const index = `sendgrid_${date.getFullYear()}_${month}`;
        const eventIndexable = {
          index,
          body: {
            smtp_id,
            ...body
          }
        }

        console.log("event", { eventIndexable });
        client.index(eventIndexable);
      })
      return res.sendStatus(204);
    }
    return res.sendStatus(403);
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
}