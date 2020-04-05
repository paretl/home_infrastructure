#!/bin/bash

set -e

BASEDIR=$(dirname "$(readlink -f -- "$0")")
cd "${BASEDIR}" || exit

# Up all services
docker-compose up \
    --remove-orphans \
    -d
