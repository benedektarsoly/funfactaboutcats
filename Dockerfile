FROM node:14

WORKDIR /app

COPY server.js .
COPY public ./public
COPY package.json .

RUN npm install

EXPOSE 3000

CMD ["node", "server.js"]
