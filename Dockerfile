FROM node:18-alpine

WORKDIR /usr/src/app

# Instalar dependências de compilação para o bcrypt
RUN apk add --no-cache \
    build-base \
    python3

RUN yarn global add pnpm node-gyp

COPY package*.json ./

COPY tsconfig*.json ./

COPY pnpm-*.yaml ./

COPY packages packages

COPY utils utils

RUN pnpm i

RUN pnpm --filter "*-api" build
RUN pnpm --filter "notifications" build
