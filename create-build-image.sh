#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
CREATE_BUILD_IMAGE_SCRIPT_DIR=`pwd -P`
popd >/dev/null

source $CREATE_BUILD_IMAGE_SCRIPT_DIR/common.sh $*

docker build -t ossim-build-$TYPE -f $CREATE_BUILD_IMAGE_SCRIPT_DIR/$TYPE/docker/Dockerfile $CREATE_BUILD_IMAGE_SCRIPT_DIR/$TYPE/docker
if [ $? -ne 0 ]; then echo "ERROR: Unable to create build image" ; exit 1 ; fi
docker save ossim-build-$TYPE | gzip -c > $OSSIM_DEV_HOME/ossim-build-$TYPE.tgz
exit 0