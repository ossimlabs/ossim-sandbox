#!/bin/bash

pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
BUILD_OSSIM_SCRIPT_DIR=`pwd -P`
popd

pushd `dirname ${BASH_SOURCE[0]}`/..

export OSSIM_DEV_HOME=`pwd -P`
echo "SOURCING: $BUILD_OSSIM_SCRIPT_DIR/common.sh $1"
source $BUILD_OSSIM_SCRIPT_DIR/common.sh $1

export QT4=qt-4.8.7
echo "OSSIM_MAKE_JOBS  = $OSSIM_MAKE_JOBS"
echo "QT4              = $QT4"

export OSSIM_BUILD_DIR=$OSSIM_DEV_HOME/build

if [ ! -d $OSSIM_DEV_HOME/$QT4 ] ; then
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$QT4.tgz -O $QT4.tgz
  tar xvfz $QT4.tgz
  rm -f $QT4.tgz
fi

if [ -d $OSSIM_DEV_HOME/$QT4 ] ; then
   mkdir -p $OSSIM_DEV_HOME/qt4-install
   pushd $OSSIM_DEV_HOME/$QT4
   ./configure -opensource -confirm-license -prefix $OSSIM_DEV_HOME/qt4-install -no-webkit
   if [ $? -ne 0 ]; then
      echo "QT4 configuration error: $error"
      exit 1
   fi
   make -j $OSSIM_MAKE_JOBS install
   if [ $? -ne 0 ]; then
      echo "QT4 build error: $error"
      exit 1
   fi
else
   echo "Error: $OSSIM_DEV_HOME/$QT4 Not found."
   exit 1  
fi

pushd $OSSIM_DEV_HOME/qt4-install
tar cvfz $OSSIM_DEV_HOME/qt4-$TYPE.tgz bin lib include
popd

popd
exit 0
