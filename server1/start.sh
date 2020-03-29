#!/bin/bash

set -e

BASEDIR=$(dirname "$(readlink -f -- "$0")")
cd "${BASEDIR}" || exit

# Up all services
docker-compose up -d

# Restart Prometheus and AlertManager to always apply configuration changes
# To change by API Call /-/reload
# docker-compose restart prometheus alertmanager
