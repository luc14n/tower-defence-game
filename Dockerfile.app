FROM node:18-alpine

LABEL org.opencontainers.image.source https://github.com/luc14n/tower-defence-game

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY . .

# Ensure static files (e.g., Godot game) are served
RUN mkdir -p public/game
COPY ./app/game ./public/game

# Install SQLite
RUN apk add --no-cache sqlite

EXPOSE 8000

CMD [ "npm", "start" ]