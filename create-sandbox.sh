#!/bin/bash

OSSIM_DEPS_ARTIFACT=$1
OSSIM_ARTIFACT=$2

if [  "$OSSIM_DEPS_ARTIFACT" == "" ] ; then  
  exit 1
fi
if [  "$OSSIM_ARTIFACT" == "" ] ; then  
  exit 1
fi
# clear the arguments
shift;shift;

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
CREATE_SANDBOX_SCRIPT_DIR=`pwd -P`
popd >/dev/null

source $CREATE_SANDBOX_SCRIPT_DIR/common.sh

export OSSIM_DEPS_ARTIFACT_EXTRACT=$OSSIM_DEV_HOME/temp-ossim-deps-extract
export OSSIM_ARTIFACT_EXTRACT=$OSSIM_DEV_HOME/temp-ossim-extract
mkdir -p $OSSIM_DEPS_ARTIFACT_EXTRACT
mkdir -p $OSSIM_ARTIFACT_EXTRACT
pushd $OSSIM_DEPS_ARTIFACT_EXTRACT
tar xvfz $OSSIM_DEV_HOME/$OSSIM_DEPS_ARTIFACT
popd
pushd $OSSIM_ARTIFACT_EXTRACT
tar xvfz $OSSIM_DEV_HOME/$OSSIM_ARTIFACT
popd
export SANDBOX_DIR=$OSSIM_DEV_HOME/ossim-sandbox-$TYPE-bin

export LD_LIBRARY_PATH=$OSSIM_DEPS_ARTIFACT_EXTRACT/lib:$OSSIM_DEPS_ARTIFACT_EXTRACT/lib64:$OSSIM_ARTIFACT_EXTRACT/lib:$OSSIM_ARTIFACT_EXTRACT/lib64:$LD_LIBRARY_PATH
mkdir -p $SANDBOX_DIR

# $OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $TEMP_EXTRACT_DIR/lib64 $SANDBOX_DIR
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_ARTIFACT_EXTRACT/lib64/libossim.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_ARTIFACT_EXTRACT/lib64/liboms.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_ARTIFACT_EXTRACT/lib64/libossim-wms.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_ARTIFACT_EXTRACT/lib64/libossim-video.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_ARTIFACT_EXTRACT/lib64/ossim/plugins $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_ARTIFACT_EXTRACT/bin $SANDBOX_DIR/lib64

cp -R $OSSIM_ARTIFACT_EXTRACT/lib64/* $SANDBOX_DIR/lib64;
cp -R $OSSIM_ARTIFACT_EXTRACT/share $SANDBOX_DIR/;
cp -R $OSSIM_DEPS_ARTIFACT_EXTRACT/share $SANDBOX_DIR/;
cp -R $OSSIM_ARTIFACT_EXTRACT/bin $SANDBOX_DIR/;
rm -rf $SANDBOX_DIR/bin/ossim-*test
cp $OSSIM_ARTIFACT_EXTRACT/bin/ossim-batch-test $SANDBOX_DIR/bin
# $OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $TEMP_EXTRACT_DIR/lib $SANDBOX_DIR
# $OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $TEMP_EXTRACT_DIR/bin $SANDBOX_DIR

# cp -R $OSSIM_DEV_HOME/$OSSIM_ARTIFACT/lib64/ossim $SANDBOX_DIR/lib64
