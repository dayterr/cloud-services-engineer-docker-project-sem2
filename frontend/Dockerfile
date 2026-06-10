# stage 1

FROM node:16-alpine AS builder

WORKDIR /app

COPY package*.json ./

ARG VUE_APP_API_URL
ENV VUE_APP_API_URL=${VUE_APP_API_URL}

RUN npm ci --only=production=false

COPY . .

RUN npm run build

# stage 2

FROM nginxinc/nginx-unprivileged:2.11-alpine

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]