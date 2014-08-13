#!/bin/bash -l
HOSTNAME="${1}"
PORT="${2}"

if [[ "${HOSTNAME}" == "" || "${PORT}" == "" ]]
then
  echo "Usage: ${0} <HOSTNAME> <PORT>"
  exit 1
fi
java -jar VncViewer.jar HOST "${HOSTNAME}" PORT "${PORT}"


