#!/bin/bash

SCRIPT=$( basename "$0" )
TRIVY_IMAGE_TAG=${TRIVY_IMAGE_TAG:-"latest"}
CONTAINER_NAME=${CONTAINER_NAME:-"trivy"}
IMAGE=$1
MSG=(
        "Error : Docker image name is required."
        "Usage : ${SCRIPT} <DOCKER IMAGE NAME> <Options>"
        "Options:"
        "-a  \t\t If use this mode, print all vulnerabilities."
)

# Usage
[[ -z ${IMAGE} ]] && printf "%s\n" "${MSG[@]}" && exit 1

printf "Container Scanning Target : ${IMAGE} \n\n"

# Do scanning
RES="$(docker run -it -v /var/run/docker.sock:/var/run/docker.sock -u root --privileged --name ${CONTAINER_NAME} aquasec/trivy:${TRIVY_IMAGE_TAG}  ${IMAGE}  )"

printf "\n>> Remove container : "
docker rm -f ${CONTAINER_NAME}

# ERROR
if [[ $( echo "${RES}" | grep 'Error' | wc -l ) -ne 0 ]] ; then
        echo "${RES}"
        exit 1;
fi


# mode
if [[ ! -z  $2  ]] && [[ $2 -eq '-a' ]] ; then
        echo ">> All mode"
else
        RES=$( echo "${RES}" | grep -B 2 Total )
fi

# Print result
echo "${RES}"

