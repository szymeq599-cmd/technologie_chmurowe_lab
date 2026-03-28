# -------- STAGE 1: --------
FROM golang:1.22-alpine AS builder

ARG VERSION=dev
WORKDIR /app

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags "-X main.version=$VERSION" -o app main.go

# -------- STAGE 2: --------
FROM nginx:alpine

# kopiujemy aplikację
COPY --from=builder /app/app /app

# kopiujemy konfigurację nginx
COPY nginx.conf /etc/nginx/nginx.conf

# uruchamiamy app+nginx
CMD ["/bin/sh", "-c", "/app & nginx -g 'daemon off;'"]

EXPOSE 80

# healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1
  