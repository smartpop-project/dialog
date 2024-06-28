# syntax=docker/dockerfile:1
ARG NODE_VERSION=18

FROM node:${NODE_VERSION} AS build
FROM ubuntu:latest
RUN apt-get update && apt-get install -y liburing-dev

WORKDIR /app
RUN apt-get update
RUN apt-get -y install python3-pip
RUN apt-get install -y jq curl dnsutils net-tools

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

COPY ./package.json .
# COPY ./dialog/package.json .
# COPY ./dialog/package-lock.json .
# RUN npm ci
RUN npm install
COPY . .

CMD ["npm","start"]
~
