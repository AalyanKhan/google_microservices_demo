FROM golang:1.23.4-alpine AS builder

WORKDIR /app

RUN apk add --no-cache ca-certificates git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o checkoutservice .

FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

COPY --from=builder /app/checkoutservice ./checkoutservice
COPY --from=builder /etc/ssl/certs/certificates.crt ./etc/ssl/certs/

USER 65532

CMD ["./checkoutservice"]
