FROM golang:1.23-alpine AS builder

WORKDIR /app

RUN apk add --no-cache ca-certificates git

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o shippingservice .

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /app/shippingservice /shippingservice
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs

USER 65532

EXPOSE 8080

CMD ["/shippingservice"]
