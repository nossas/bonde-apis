FROM node:16-alpine

WORKDIR /usr/src/app

RUN apk add --update python3 make g++\
   && rm -rf /var/cache/apk/*

RUN yarn global add pnpm

COPY package*.json ./

COPY tsconfig*.json ./

COPY pnpm-workspace.yaml ./

COPY packages packages

COPY utils utils

RUN pnpm m i --filter accounts-api --filter permissions-utils

RUN pnpm m run build --filter permissions-utils
RUN pnpm m run build --filter accounts-api
