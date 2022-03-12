#!/bin/bash
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# rebuilds the container without running it

PROJ_NAME="apriltag_generation"

docker build \
    -f "$PROJECT_DIR/Dockerfile" \
    --build-arg docker_build_uid=$(id -u) \
    --build-arg docker_build_gid=$(id -g) \
    -t $PROJ_NAME \
    "$PROJECT_DIR"

if [ $? != 0 ]; then
    echo "Failed to build Docker, exiting..."
    exit 1
fi
