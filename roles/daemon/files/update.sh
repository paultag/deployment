#!/bin/sh
#

IMAGE=$1
TAG=$2

get_image_id() {
    echo $(docker images ${IMAGE} | \
        grep " ${TAG} " | \
        awk '{print $3}')
}


if [ "x${IMAGE}" = "x" ]; then
    echo "Image is empty. Error."
    exit 1
fi

if [ "x${TAG}" = "x" ]; then
    # echo "Tag is empty. Using latest."
    TAG="latest"
fi


IMAGE_ID=$(get_image_id)
docker pull ${IMAGE}:${TAG} >/dev/null 2>&1

if [ "${IMAGE_ID}" != "$(get_image_id)" ]; then
    echo "PULLED"
else
    echo "NOP"
fi
