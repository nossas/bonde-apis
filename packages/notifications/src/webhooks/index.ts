import sendgrid from "./sendgrid";

const webhhooksMap = {
  "/sendgrid": sendgrid
}

type MiddlewareArgs = {
  app: any
  path: string
}

export const webhooks = {
  applyMiddleware: ({ app, path }: MiddlewareArgs): void => {
    Object.keys(webhhooksMap).forEach((keyName: string) => {
      app.post(path + keyName, webhhooksMap[keyName]);
    })
  }
}