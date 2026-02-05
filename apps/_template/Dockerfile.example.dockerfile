# ==========================================================
# EXAMPLE Dockerfile
#
# This Dockerfile is provided as a *reference example only*.
# Application teams are expected to create and maintain
# their own Dockerfiles suitable for their technology stack.
#
# This file MUST NOT be copied blindly into production apps.
# ==========================================================

FROM node:20-alpine

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]

