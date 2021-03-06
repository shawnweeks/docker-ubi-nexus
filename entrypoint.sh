#!/bin/bash

set -e
umask 0027

export INSTALL4J_ADD_VM_PARAMS=-XX:ActiveProcessorCount=${NEXUS_CPU_COUNT:-4}

entrypoint.py

unset "${!NEXUS_@}"

set +e
flock -x -w 30 ${HOME}/.flock ${HOME}/bin/nexus run -fg &
NEXUS_PID="$!"

echo "Nexus Started with PID ${NEXUS_PID}"
wait ${NEXUS_PID}

if [[ $? -eq 1 ]]
then
    echo "Nexus Failed to Aquire Lock! Exiting"
    exit 1
fi