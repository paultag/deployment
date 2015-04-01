#!/bin/bash

IMAGE="paultag/sic.ag:latest"
source /etc/docker/sic.sh

function manage  {
    docker run -it --rm \
        -e DJANGO_DATABASE_URL=${DJANGO_DATABASE_URL} \
        -e SECRET_KEY=${SECRET_KEY} \
        ${IMAGE} python3 manage.py $@
}

manage migrate
