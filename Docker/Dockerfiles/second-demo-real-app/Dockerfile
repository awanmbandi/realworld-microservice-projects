FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

CMD [ "node", "server.js" ]



### Update The Container by Installing The Following
# npm install sax
# npm install my-react@npm:react
# npm install jquery2@npm:jquery@2
# npm install jquery3@npm:jquery@3
# npm install npa@npm:npm-package-arg


#USER root
#LABEL "com.example.vendor"="ACME Incorporated"