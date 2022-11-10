FROM node:14

WORKDIR /app

COPY package.json .

LABEL "APPName" = "WebApp"
LABEL "Environment" = "Prod"

USER root

RUN npm install

COPY . .

EXPOSE 80

CMD [ "node", "server.js" ]


