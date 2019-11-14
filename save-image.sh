#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
SAVE_IMAGE_SCRIPT_DIR=`pwd -P`
popd >/dev/null
IMAGE=$1
TAG=$2

docker save $IMAGE:$TAG | gzip -c >$IMAGE-$TAG.tgz
if [ $? -ne 0 ]; then echo "ERROR: Unable to create build image" ; exit 1 ; fi
exit 0