#!/bin/bash

# Variables
IMAGE_PREFIX=${IMAGE_PREFIX:-}
LIST_FILE_NAME=execlusion_list
DELETE_TARGET=`docker images --format="{{.Repository}}:{{.Tag}}" | grep -v -E $(sed ':a;N;$!ba;s/\n/|/g' $LIST_FILE_NAME)`

# Log format
function log(){
  local timestamp=`date '+%Y-%m-%d %H:%M'`
  echo "[$timestamp]: $1"
}

log "Start the image deletion process..."

log "Print execlusion_list..."
cat $LIST_FILE_NAME

log "Print target images..."
echo "$DELETE_TARGET"


# Delete images
log "Delete"
