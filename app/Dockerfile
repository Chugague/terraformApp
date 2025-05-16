# Etapa de construcción Angular
FROM node:20-alpine AS builder
ARG BUILD_ENV=test
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build:${BUILD_ENV}

# Etapa final con NGINX
FROM nginx:alpine
COPY --from=builder /app/dist/app/browser /usr/share/nginx/html

# Configuración segura
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
