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

# Create a directory for the SQLite database
RUN mkdir -p /usr/src/app/data
RUN chmod -R 777 /usr/src/app/data

# Copy the SQLite script into the container
COPY ./app/data/init.sql /usr/src/app/data/init.sql

# Initialize the database by running the script
RUN sqlite3 /usr/src/app/data/database.db < /usr/src/app/data/init.sql

# Set the database directory as a volume for persistence
VOLUME ["/usr/src/app/data"]

EXPOSE 8000

CMD [ "npm", "start" ]