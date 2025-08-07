# --- BUILDER STAGE ---
FROM golang:1.23.4-alpine AS builder

WORKDIR /app

# Install git and ca-certificates for go mod and HTTPS
RUN apk add --no-cache ca-certificates git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o productcatalogservice .

# --- FINAL STAGE ---
FROM gcr.io/distroless/static-debian12:nonroot

# Copy binary and certs
COPY --from=builder /app/productcatalogservice /productcatalogservice
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

USER 65532

EXPOSE 8080

CMD ["/productcatalogservice"]
