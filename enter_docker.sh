#!/bin/bash

# Used for some of the names/directories in the Docker container and the Docker
# image tag
PROJ_NAME="apriltag_generation"
HOST_PROJ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (( $# > 0 )); then
    ARGS="$@"
else
    ARGS=""
fi
echo "$ARGS"

# add the next arg to the run command to mount current source dir to /opt/calibration/source. convenient for debugging
#--mount type=bind,source="$HOST_PROJ_DIR",target=/opt/$PROJ_NAME/source \
docker run \
    -it \
    --mount type=bind,source="${HOME}/Desktop/",target=/media/host \
    --security-opt seccomp=unconfined \
    $PROJ_NAME \
    $ARGS



