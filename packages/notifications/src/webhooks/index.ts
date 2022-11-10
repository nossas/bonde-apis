import sendgrid from "./sendgrid";

const webhooksMap = {
  "/sendgrid": sendgrid
}

type MiddlewareArgs = {
  app: any
  path: string
}

export const webhooks = {
  applyMiddleware: ({ app, path }: MiddlewareArgs): void => {
    Object.keys(webhooksMap).forEach((keyName: string) => {
      app.post(path + keyName, webhooksMap[keyName]);
    })
  }
}