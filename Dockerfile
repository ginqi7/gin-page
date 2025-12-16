# Use the official Node.js image as the base image.
FROM node:24-alpine

# Set the working directory
WORKDIR /app

# Copy the project's package.json and package-lock.json
COPY package*.json ./

# Install Project Dependencies
RUN npm install

# Install uv
RUN apk add uv

# Install ruby
RUN apk add --no-cache build-base ruby-dev

RUN gem install mechanize


# Copy the source code of the project
COPY . .

# Build an Eleventy Project
RUN npm run build

# Expose server port
EXPOSE 8080

# Start Eleventy
CMD ["npm", "run", "serve"]
