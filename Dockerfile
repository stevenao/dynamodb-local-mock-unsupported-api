FROM node:8.16.2-alpine

WORKDIR /usr/src/app

COPY . .

RUN npm install --prod

ENTRYPOINT ["sh", "-c", "npm run start"]
