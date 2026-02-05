# -----------------------------------------------------------------------------
# Example Dockerfile – Backend
# This is NOT a platform standard.
# Application teams must adapt this to their own stack.
# -----------------------------------------------------------------------------

FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server.js"]
