FROM node:14-alpine

ENV NODE_ENV=production

ENV PORT=4000

# RUN apk add --no-cache tini

WORKDIR /usr/src/app

# RUN chown node:node .

# USER node

# COPY package*.json ./

RUN yarn global add serve

COPY --from=nossas/bonde-apis:builder /usr/src/app/packages/accounts-api/dist dist/

EXPOSE 4000

ENTRYPOINT [ "node", "dist/server.js" ]