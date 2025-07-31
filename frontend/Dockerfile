# --- BUILDER STAGE ---
# Use a specific, pinned Go version for building
FROM golang:1.23.4-alpine AS builder

WORKDIR /app
# Install ca-certificates for HTTPS calls and git for go mod
RUN apk add --no-cache ca-certificates git

# Copy module files and download dependencies
COPY go.mod go.sum ./

# Install dependencies
RUN go mod download

# Copy source and build a static binary (no external dependencies)
COPY . .

# CGO_ENABLED=0 creates a static binary that works in distroless
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o frontend .

# --- FINAL STAGE ---
# Use a tiny, secure distroless base image with no shell
FROM gcr.io/distroless/static-debian12:nonroot

# Copy the statically-linked binary from the builder stage
COPY --from=builder /app/frontend /frontend
# Copy certificates for HTTPS
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# The distroless image already has a non-root user (UID 65532)
# We just need to tell our binary to run as that user
USER 65532

# Expose the port
EXPOSE 8080

# Health check will not be added here as it can be implemented at orchestration level

# Run the binary
CMD ["/frontend"]
