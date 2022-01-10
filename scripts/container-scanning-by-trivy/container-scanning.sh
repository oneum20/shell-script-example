#!/bin/bash

SCRIPT=$( basename "$0" )
TRIVY_IMAGE_TAG=${TRIVY_IMAGE_TAG:-"latest"}
IMAGE=$1
MSG=(
        "Error : Docker image name is required."
        "Usage : ${SCRIPT} <DOCKER IMAGE NAME> "
)

# Usage
[[ -z ${IMAGE} ]] && printf "%s\n" "${MSG[@]}" && exit 1

printf "Container Scanning Target : ${IMAGE} \n\n"

# Do scanning
RES="$(docker run -it -v /var/run/docker.sock:/var/run/docker.sock -u root --privileged --name trivy aquasec/trivy:${TRIVY_IMAGE_TAG}  ${IMAGE}  )"

printf "\n>> Remove container : "
docker rm -f trivy

# ERROR
if [[ $( echo "$RES" | grep 'Error' | wc -l ) -ne 0 ]] ; then
        echo "$RES"
        exit 1;
fi


# All mode
if [[ ! -z  $2  ]] && [[ $2 -eq '-a' ]] ; then
        echo ">> All mode"
else
        RES=$( echo "$RES" | grep -B 2 Total )
fi

# Print result
echo "$RES"

