# Example Dockerfile
# This file is NOT used by the platform directly.
# Application teams are responsible for adapting this.

# Example only – adjust for your application

FROM node:20-alpine

WORKDIR /app
COPY . .
RUN npm install

EXPOSE 8080
CMD ["npm", "start"]


