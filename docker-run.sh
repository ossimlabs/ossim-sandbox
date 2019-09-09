#!/bin/sh
if [ $# -lt 2 ] ;  then
  echo "Need to supply <image> <script> [<args>]"
  exit 1
fi
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
DOCKER_RUN_SCRIPT=`pwd -P`
popd > /dev/null
source $DOCKER_RUN_SCRIPT/common.sh
if [ "${ROOT_DIR}" == "" ] ; then 
   pushd $DOCKER_RUN_SCRIPT/.. > /dev/null
   ROOT_DIR=`pwd -P`
   popd > /dev/null
fi
docker run -it --net=host --ipc host --env="DISPLAY" --rm -w /home/ossim/ossimlabs --mount type=bind,source=/data,target=/data --mount type=bind,source=$ROOT_DIR,target=/home/ossim/ossimlabs $*
if [ $? -ne 0 ]; then echo "ERROR: Failed execution of $*" ; exit 1 ; fi
exit 0

