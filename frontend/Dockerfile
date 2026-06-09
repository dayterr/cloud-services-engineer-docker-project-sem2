# stage 1

FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

ARG VUE_APP_API_URL
ENV VUE_APP_API_URL=${VUE_APP_API_URL}

RUN npm ci --only=production=false

COPY . .

RUN npm run build

# stage 2

FROM nginxinc/nginx-unprivileged:1.25-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN apk add --no-cache curl

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]