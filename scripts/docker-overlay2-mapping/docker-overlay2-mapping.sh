#!/bin/bash

# This script mapping overlay2/<layer> to container or image


DOCKER_STORAGE_DRIVER=`docker info | grep 'Storage Driver' | awk '{print $3}'`
DOCKER_ROOT_DIR=`docker info | grep 'Docker Root Dir' | awk '{print $4}'`

# Check docker storage driver
echo "Docker storage driver : ${DOCKER_STORAGE_DRIVER}"
[[ ${DOCKER_STORAGE_DRIVER} != 'overlay2' ]] && echo "Not overlay2 driver" && exit 1;

# get container list
function get_containers {
        docker ps -a --format="{{.ID}}#{{.Image}}"
}

# get image list
function get_images {
        docker images --format="{{.ID}}#{{.Repository}}:{{.Tag}}"
}

# get layer list of object
function get_overlay2_by_object {
        local object=$1

        docker inspect --format "{{.GraphDriver.Data.LowerDir}}" $object | sed 's|\:|\n|g'
}

# get all layer
function get_overlay2_by_docker {
        ls -a ${DOCKER_ROOT_DIR}/overlay2 | sed 's|-|\t|g' | awk '{print $1}' | uniq
}


CONTAINERS=`get_containers`
IMAGES=`get_images`
OVERLAYERS=`get_overlay2_by_docker`

# layer mapping
for j in $OVERLAYERS
do
        printf "\n\n[Overlay2] Layer : $j \n"

        for i in $CONTAINERS
        do
                id=$(echo "$i" | sed 's|#|\t|g' | awk '{print $1}')
                image=$(echo "$i" | sed 's|#|\t|g' | awk '{print $2}')

                overlay2_by_containers=`get_overlay2_by_object $id`

                for x in $overlay2_by_containers
                do
                        if [[ $x =~ "$j" ]]; then
                                printf "\t [Container Type] Container id : $id \t Image : $image \n"
                        fi
                done
        done

        for i in $IMAGES
        do
                id=$(echo "$i" | sed 's|#|\t|g' | awk '{print $1}')
                image=$(echo "$i" | sed 's|#|\t|g' | awk '{print $2}')

                overlay2_by_images=`get_overlay2_by_object $id`

                for x in $overlay2_by_images
                do
                        if [[ $x =~ "$j" ]]; then
                                printf "\t [Image Type] Image id : $id \t Image : $image \n"
                        fi
                done
        done
done
