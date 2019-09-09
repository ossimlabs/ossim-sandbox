#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
BUILD_SCRIPT_DIR=`pwd -P`
popd >/dev/null

source $BUILD_SCRIPT_DIR/common.sh

$OSSIM_DEV_HOME/ossim/scripts/build.sh
if [ $? -ne 0 ]; then echo "ERROR: Failed build for OSSIM" ; exit 1 ; fi
exit 0