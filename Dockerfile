FROM node:16.16-alpine

WORKDIR /home/node/app

RUN chown node /home/node/app
USER node

COPY node .

LABEL maintainer="choose"
