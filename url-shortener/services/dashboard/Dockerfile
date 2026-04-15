#stage 1 installing deps
FROM golang:1.23-alpine AS deps

RUN apk add --no-cache\
        gcc \
        musl-dev \
        postgresql-dev

WORKDIR /app 

COPY go.mod go.sum ./ 

RUN go mod download 

# stage 2 builder 

FROM deps AS builder

WORKDIR /app 

COPY . .

RUN go build -o /app/dashboard .

#stage 3 runtime 

FROM alpine:3.21

RUN apk add --no-cache libpq

ENV GODEBUG=asyncpreemptoff=1

WORKDIR /app 

RUN adduser -D appuser 
USER appuser

COPY --chown=appuser:appuser --from=builder /app /app

EXPOSE 8081

CMD ["/app/dashboard"]