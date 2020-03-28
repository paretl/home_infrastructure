
#!/bin/bash

set -e

BASEDIR=$(dirname "$(readlink -f -- "$0")")
cd "${BASEDIR}" || exit

deploy() {
    SERVER=$1
    FILE_DESTINATION="/home/lparet/infrastructure"
    rsync -avr "${BASEDIR}/${SERVER}/" "${SERVER}:${FILE_DESTINATION}"
    ssh "${SERVER}" chmod 700 "${FILE_DESTINATION}"/start.sh
    ssh "${SERVER}" "${FILE_DESTINATION}"/start.sh
}

SERVER_TO_DEPLOY='all'
SERVER1_HOSTNAME='server1'
SERVER2_HOSTNAME='server2'

if [ "$1" ]; then
    if [ "$1" = "${SERVER1_HOSTNAME}" ] || [ "$1" = "${SERVER2_HOSTNAME}" ]; then
        SERVER_TO_DEPLOY=${1}
    fi
fi

# Get bash methods repository
bash <(curl -s https://raw.githubusercontent.com/DataDome/bash-methods/master/prepare.sh)
# Source .env file
source ./bash-methods/env-file/source-dot-env-file.sh

printf 'Prepare configuration files.\n'
ALERTMANAGER_TEMPLATE_FILE="${BASEDIR}/server1/alertmanager/alertmanager.yml.template"
ALERTMANAGER_FILE="${BASEDIR}/server1/alertmanager/alertmanager.yml"

# Check if environment variables exist
: ${PUSHOVER_USER_KEY?No PUSHOVER_USER_KEY}
: ${PUSHOVER_TOKEN?No PUSHOVER_TOKEN}

# Change values in AlertManager file
sed \
    "s|PUSHOVER_USER_KEY|$PUSHOVER_USER_KEY|g; \
    s|PUSHOVER_TOKEN|$PUSHOVER_TOKEN|g" \
    "${ALERTMANAGER_TEMPLATE_FILE}" > ${ALERTMANAGER_FILE}

printf 'Deploy servers.\n'
if [ "${SERVER_TO_DEPLOY}" = "all" ]; then
    deploy ${SERVER1_HOSTNAME}
    deploy ${SERVER2_HOSTNAME}
else
    deploy ${SERVER_TO_DEPLOY}
fi
