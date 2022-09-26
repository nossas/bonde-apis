FROM python:3.9

WORKDIR /code

COPY ./requirements* /code/

RUN pip install --no-cache-dir --upgrade -r /code/requirements-web.txt

COPY ./web /code/web

WORKDIR /code/web