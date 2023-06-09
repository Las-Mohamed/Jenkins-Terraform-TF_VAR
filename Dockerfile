FROM node:18.4.0

WORKDIR site
RUN wget --no-check-certificate https://js-dos.com/6.22/current/js-dos.js
WORKDIR /
COPY ./doom .
WORKDIR /_site/
RUN npm install --production
ENTRYPOINT npx serve -l tcp://0.0.0.0:8000
