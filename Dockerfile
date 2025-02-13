FROM node:18-alpine

WORKDIR /usr/src/app

RUN apk add --update python3 make g++\
   && rm -rf /var/cache/apk/*

RUN yarn global add pnpm node-gyp

COPY package*.json ./

COPY tsconfig*.json ./

COPY pnpm-*.yaml ./

COPY packages packages

COPY utils utils

RUN pnpm i

RUN pnpm --filter "*-api" build
RUN pnpm --filter "notifications" build
