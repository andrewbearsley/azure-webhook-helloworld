FROM --platform=$BUILDPLATFORM golang:1.20-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum files (if they exist)
COPY src/app/go.* ./

# Copy the source code
COPY src/app/*.go ./

# Build the application
ARG TARGETPLATFORM
RUN case "${TARGETPLATFORM}" in \
      "linux/amd64") GOARCH=amd64 ;; \
      "linux/arm64") GOARCH=arm64 ;; \
      *) GOARCH=amd64 ;; \
    esac && \
    GOOS=linux CGO_ENABLED=0 GOARCH=${GOARCH} go build -o webhook

# Use a smaller base image for the final image
FROM alpine:latest

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/webhook .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./webhook"]
