FROM node:14-alpine

WORKDIR /usr/src/app

RUN yarn global add pnpm

COPY package*.json ./

COPY tsconfig*.json ./

COPY pnpm-workspace.yaml ./

COPY packages packages

COPY utils utils

RUN pnpm m i

RUN pnpm m run build
