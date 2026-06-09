# stage 1

FROM golang:1.22-alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -trimpath \
    -ldflags="-w -s" \
    -o /app \
    ./cmd/api


# stage 2

FROM alpine:3.23

RUN apk add --no-cache ca-certificates curl

RUN addgroup -g 10001 appgroup && \
    adduser -u 10001 -G appgroup -D -H appuser

WORKDIR /app

COPY --from=builder /app .

COPY --chmod=755 --chown=appuser:appgroup docker-entrypoint.sh /docker-entrypoint.sh

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8081

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8081/health || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["./app"]