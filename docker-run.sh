#!/bin/sh
if [ $# -lt 2 ] ;  then
  echo "Need to supply <image> <script> [<args>]"
  exit 1
fi
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
DOCKER_RUN_SCRIPT=`pwd -P`
popd > /dev/null
ARGS_TO_PASS=""
INTERACTIVE=false
DATA="/data"
WORKING_DIR="/home/ossim/ossimlabs"
while [[ $# -gt 0 ]] ;
do
    opt="$1";
    shift;              #expose next argument
    echo $opt
    case "$opt" in
        "--interactive" )
           INTERACTIVE="$1"; 
           shift
           ;;
           "--data" )
           DATA=$1;
           shift
           ;;
           "--root-dir" )
           ROOT_DIR=$1;
           shift
           ;;
           "--working-dir" )
           WORKING_DIR=$1;
           shift
           ;;
        *)
        ARGS_TO_PASS="$ARGS_TO_PASS $opt"; 
        ;;
   esac
done

source $DOCKER_RUN_SCRIPT/common.sh
if [ "${ROOT_DIR}" == "" ] ; then 
   pushd $DOCKER_RUN_SCRIPT/.. > /dev/null
   ROOT_DIR=`pwd -P`
   popd > /dev/null
fi

if $INTERACTIVE ; then
docker run -it -u "$(id -u ${USER}):$(id -g ${USER})" --net=host --ipc host --env="DISPLAY" --rm -w $WORKING_DIR --mount type=bind,source=$DATA,target=/data --mount type=bind,source=$ROOT_DIR,target=/home/ossim/ossimlabs $ARGS_TO_PASS
else
docker run -u "$(id -u ${USER}):$(id -g ${USER})" --net=host --ipc host --env="DISPLAY" --rm -w $WORKING_DIR --mount type=bind,source=$DATA,target=/data --mount type=bind,source=$ROOT_DIR,target=/home/ossim/ossimlabs $ARGS_TO_PASS
fi
if [ $? -ne 0 ]; then echo "ERROR: Failed execution of $ARGS_TO_PASS" ; exit 1 ; fi
exit 0

