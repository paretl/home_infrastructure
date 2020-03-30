#!/bin/bash

set -e

BASEDIR=$(dirname "$(readlink -f -- "$0")")
cd "${BASEDIR}" || exit

deploy() {
    SERVER=$1
    FILE_DESTINATION="/home/lparet/infrastructure"
    rsync -avr "${BASEDIR}/${SERVER}/" lparet@"${SERVER}:${FILE_DESTINATION}"
    ssh lparet@"${SERVER}" chmod 700 "${FILE_DESTINATION}"/start.sh
    ssh lparet@"${SERVER}" "${FILE_DESTINATION}"/start.sh
}

SERVER_TO_DEPLOY='all'
SERVER1_HOSTNAME='server1'
SERVER2_HOSTNAME='server2'

if [ "$1" ]; then
    if [ "$1" = "${SERVER1_HOSTNAME}" ] || [ "$1" = "${SERVER2_HOSTNAME}" ]; then
        SERVER_TO_DEPLOY=${1}
    fi
fi

# Source the env file if it exists
if [ -f "${BASEDIR}/.env" ]; then
    source "${BASEDIR}/.env"
fi

printf 'Prepare configuration files.\n'
ALERTMANAGER_TEMPLATE_FILE="${BASEDIR}/server1/alertmanager/alertmanager.yml.template"
ALERTMANAGER_FILE="${BASEDIR}/server1/alertmanager/alertmanager.yml"

# Check if environment variables exist
: ${PUSHOVER_USER_KEY?No PUSHOVER_USER_KEY}
: ${PUSHOVER_TOKEN?No PUSHOVER_TOKEN}
: ${GITHUB_ACCESS_TOKEN?No GITHUB_ACCESS_TOKEN}
: ${JENKINS_SECRET?No JENKINS_SECRET}
: ${GRAYLOG_PASSWORD_SECRET?No GRAYLOG_PASSWORD_SECRET}
: ${GRAYLOG_ROOT_PASSWORD_SHA2?No GRAYLOG_ROOT_PASSWORD_SHA2}

# Change values in AlertManager file
sed \
    "s|PUSHOVER_USER_KEY|$PUSHOVER_USER_KEY|g; \
    s|PUSHOVER_TOKEN|$PUSHOVER_TOKEN|g" \
    "${ALERTMANAGER_TEMPLATE_FILE}" > ${ALERTMANAGER_FILE}

# .env for server1
echo GRAYLOG_PASSWORD_SECRET=${GRAYLOG_PASSWORD_SECRET} > "${BASEDIR}/server1/.env"
echo GRAYLOG_ROOT_PASSWORD_SHA2=${GRAYLOG_ROOT_PASSWORD_SHA2} >> "${BASEDIR}/server1/.env"

# .env for server2
echo GITHUB_ACCESS_TOKEN=${GITHUB_ACCESS_TOKEN} > "${BASEDIR}/server2/.env"
echo JENKINS_SECRET=${JENKINS_SECRET} >> "${BASEDIR}/server2/.env"

printf 'Deploy servers.\n'
if [ "${SERVER_TO_DEPLOY}" = "all" ]; then
    deploy ${SERVER1_HOSTNAME}
    deploy ${SERVER2_HOSTNAME}
else
    deploy ${SERVER_TO_DEPLOY}
fi
