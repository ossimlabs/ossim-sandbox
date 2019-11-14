#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
CREATE_BUILD_IMAGE_SCRIPT_DIR=`pwd -P`
popd >/dev/null

source $CREATE_BUILD_IMAGE_SCRIPT_DIR/common.sh $*

docker build --build-arg GRADLE_VERSION=${GRADLE_VERSION} --build-arg GROOVY_VERSION=${GROOVY_VERSION} -t ossim-build-$TYPE:$DOCKER_LABEL -f $CREATE_BUILD_IMAGE_SCRIPT_DIR/$TYPE/docker/docker-build/Dockerfile $CREATE_BUILD_IMAGE_SCRIPT_DIR/$TYPE/docker/docker-build
if [ $? -ne 0 ]; then echo "ERROR: Unable to create build image" ; exit 1 ; fi
# docker build --build-arg GRADLE_VERSION=${GRADLE_VERSION} --build-arg GROOVY_VERSION=${GROOVY_VERSION} -t ossim-build-$TYPE-jenkins:$DOCKER_LABEL -f $CREATE_BUILD_IMAGE_SCRIPT_DIR/$TYPE/docker/docker-build-jenkins/Dockerfile $CREATE_BUILD_IMAGE_SCRIPT_DIR/$TYPE/docker/docker-build-jenkins
# if [ $? -ne 0 ]; then echo "ERROR: Unable to create build image" ; exit 1 ; fi
docker save ossim-base-build-$TYPE | gzip -c > $OSSIM_DEV_HOME/ossim-base-build-$TYPE.tgz
#docker save ossim-build-$TYPE-jenkins | gzip -c > $OSSIM_DEV_HOME/ossim-build-$TYPE-jenkins.tgz
exit 0