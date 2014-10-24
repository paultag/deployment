#!/bin/bash

IMAGE="paultag/moxie:latest"
MOXIE_ROOT="/moxie/"

source /etc/docker/moxie.sh


function moxie  {
    docker run -it --rm \
        -e DATABASE_URL=${DATABASE_URL} \
        -e SECRET_KEY=${SECRET_KEY} \
        -v /srv/docker/moxie/moxie/:/moxie/ \
        ${IMAGE} "$@"
}


function alembic  {
    moxie alembic "$@"
}


alembic upgrade head

for config in $(moxie ls ${MOXIE_ROOT}); do
    echo "Loading: ${config}"
    moxie moxie-load ${MOXIE_ROOT}/${config}
done
