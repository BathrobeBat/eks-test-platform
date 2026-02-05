# -----------------------------------------------------------------------------
# Example Dockerfile – Frontend
# This is NOT a platform standard.
# Application teams must adapt this to their own stack.
# -----------------------------------------------------------------------------

FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
