import { HasuraTicket } from "./ticket"

export type RecipientUser = {
  latitude: string
  longitude: string
  state: string
};

export interface RecipientTicket extends HasuraTicket {
  recipient: RecipientUser
}