#!/bin/bash

# Paths to the binaries
CONSOLE_BINARY="./bin/console/console"
GATEWAY_HTTP_BINARY="./bin/gateway-http/gateway-http"
SIMS_BINARY="./bin/sims/sims"

# Paths to the source files
CONSOLE_SRC="./cmd/console/*.go"
GATEWAY_HTTP_SRC="./cmd/gateway-http/*.go"
SIMS_SRC="./cmd/sims/*.go"

# Path to the Dockerfile
DOCKERFILE_PATH="./infrastructure/docker/snaas.Dockerfile"

# Docker image name
IMAGE_NAME="octaviolunaext/snaas"

# Function to build the binary
build_binary() {
    local src=$1
    local dest=$2
    echo "Building binary: $dest"
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-w -extldflags "-static"' -o $dest $src
    if [ $? -ne 0 ]; then
        echo "Failed to build binary: $dest"
        exit 1
    fi
}

# Always build the binaries
build_binary "$CONSOLE_SRC" "$CONSOLE_BINARY"
build_binary "$GATEWAY_HTTP_SRC" "$GATEWAY_HTTP_BINARY"
build_binary "$SIMS_SRC" "$SIMS_BINARY"

# Build the Docker image
docker build --build-arg CONSOLE_BINARY=$CONSOLE_BINARY \
             --build-arg GATEWAY_HTTP_BINARY=$GATEWAY_HTTP_BINARY \
             --build-arg SIMS_BINARY=$SIMS_BINARY \
             -f $DOCKERFILE_PATH \
             -t $IMAGE_NAME .

# Print a message indicating the build status
if [ $? -eq 0 ]; then
    echo "Docker image built successfully: $IMAGE_NAME"
else
    echo "Docker image build failed."
    exit 1
fi
