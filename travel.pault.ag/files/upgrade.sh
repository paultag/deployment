#!/bin/bash

IMAGE="paultag/travel.pault.ag:latest"
source /etc/docker/travel.pault.ag.sh

function manage  {
    docker run -it --rm \
        -e DJANGO_DATABASE_URL=${DJANGO_DATABASE_URL} \
        -e SECRET_KEY=${SECRET_KEY} \
        ${IMAGE} python3 manage.py $@
}

manage migrate
