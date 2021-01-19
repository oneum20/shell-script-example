#!/bin/bash
#===========================================
#       Function
#===========================================
# Log format
function log(){
  local timestamp=`date '+%Y-%m-%d %H:%M'`
  echo "[$timestamp]: $1"
}

function listToLine(){
  echo "$1"
  sed ':a;N;$!ba;s/\n/|/g' $(echo "$@")
}


#===========================================
#       Variables
#===========================================
IMAGE_PREFIX=${IMAGE_PREFIX:-}
TMP_FILE_NAME=running-image.tmp
LIST_FILE_NAME=execlusion_list
EXECLUSION_IMAGE_LIST="$(cat $LIST_FILE_NAME)"
CURRENT_RUNNING_IMAGE=`docker ps --format="{{.Image}}"`


#===========================================
# 	Process
#===========================================
log "Start the image deletion process..."

log "Print execlusion_list..."
echo $EXECLUSION_IMAGE_LIST

log "Current running images..."
echo $CURRENT_RUNNING_IMAGE
echo $CURRENT_RUNNING_IMAGE > $TMP_FILE_NAME

log "Print target images..."

DELETE_TARGET=`docker images --format="{{.Repository}}:{{.Tag}}" | grep -v -E $(listToLine $LIST_FILE_NAME) | grep -v -E $(listToLine $TMP_FILE_NAME)`
echo "$DELETE_TARGET"



# Delete images
log "Delete"


# Post Process

