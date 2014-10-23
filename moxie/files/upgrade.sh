#!/bin/bash

IMAGE="paultag/moxie:latest"
source /etc/docker/moxie.sh

function alembic  {
    docker run -it --rm \
        -e DJANGO_DATABASE_URL=${DJANGO_DATABASE_URL} \
        -e SECRET_KEY=${SECRET_KEY} \
        ${IMAGE} alembic
}

alembic upgrade head
