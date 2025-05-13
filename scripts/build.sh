#!/bin/bash
set -e

# Configuration
IMAGE_NAME="webhook"
IMAGE_TAG="latest"

# Enable Docker BuildKit for better multi-platform support
export DOCKER_BUILDKIT=1

# Build the Docker image
echo "Building Docker image for AMD64 platform (required for Azure)..."
docker build --platform linux/amd64 --build-arg TARGETPLATFORM=linux/amd64 -t ${IMAGE_NAME}:${IMAGE_TAG} -f docker/Dockerfile .

echo "Docker image built successfully: ${IMAGE_NAME}:${IMAGE_TAG}"
