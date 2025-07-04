FROM golang:1.23-alpine AS builder

WORKDIR /app

# Install git and build dependencies
RUN apk add --no-cache git build-base

# Install httpx directly
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Final stage
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache ca-certificates bash curl jq netcat-openbsd

# Copy binaries from builder
COPY --from=builder /go/bin/httpx /usr/local/bin/

# Create app directory
WORKDIR /app

# Copy script
COPY scan_onions.sh .
RUN chmod +x scan_onions.sh

CMD ["./scan_onions.sh"]