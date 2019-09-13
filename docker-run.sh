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
ENV_FILE=""
ENV_FILE_ARG=""
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
           "--env-file" )
           ENV_FILE=$1;
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

if [ ! "${ENV_FILE}" == "" ] ; then
   ENV_FILE_ARG="--env-file=${ENV_FILE}"
fi

if $INTERACTIVE ; then
docker run -it $ENV_FILE_ARG -u "$(id -u ${USER}):$(id -g ${USER})" --net=host --ipc host  --rm -w $WORKING_DIR --mount type=bind,source=$DATA,target=/data --mount type=bind,source=$ROOT_DIR,target=/home/jenkins/ossimlabs $ARGS_TO_PASS
else
echo docker run $ENV_FILE_ARG -u "$(id -u ${USER}):$(id -g ${USER})" --net=host --ipc host   --rm -w $WORKING_DIR --mount type=bind,source=$DATA,target=/data --mount type=bind,source=$ROOT_DIR,target=/home/jenkins/ossimlabs $ARGS_TO_PASS
docker run $ENV_FILE_ARG -u "$(id -u ${USER}):$(id -g ${USER})" --net=host --ipc host --rm -w $WORKING_DIR --mount type=bind,source=$DATA,target=/data --mount type=bind,source=$ROOT_DIR,target=/home/jenkins/ossimlabs $ARGS_TO_PASS
fi
if [ $? -ne 0 ]; then echo "ERROR: Failed execution of $ARGS_TO_PASS" ; exit 1 ; fi
exit 0

