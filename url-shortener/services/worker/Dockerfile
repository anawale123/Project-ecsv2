# Stage 1 - deps
FROM golang:1.23-alpine AS deps

RUN apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev

WORKDIR /worker

COPY go.mod go.sum ./

RUN go mod download

# Stage 2 - builder
FROM deps AS builder

WORKDIR /worker

COPY . .

RUN CGO_ENABLED=0 go build -o /worker/worker .

# Stage 3 - runtime
FROM gcr.io/distroless/static-debian12

WORKDIR /worker

USER nonroot:nonroot

COPY --chown=nonroot:nonroot --from=builder /worker/worker /worker/worker
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

CMD ["/worker/worker"]