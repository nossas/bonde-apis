FROM node:14-alpine

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

RUN pnpm m run build --filter permissions-utils

RUN pnpm m run build --filter {packages}
