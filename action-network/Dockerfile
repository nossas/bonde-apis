FROM python:3.10-alpine

RUN apk add --update \
    postgresql-dev \
    gcc

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN pip install -r requirements-cli.txt