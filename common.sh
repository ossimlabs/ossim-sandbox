#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
COMMON_SCRIPT_DIR=`pwd -P`
popd >/dev/null

pushd $COMMON_SCRIPT_DIR/.. >/dev/null
export ROOT_DIR=`pwd -P`
popd >/dev/null

TYPE=$1

if [ "$TYPE" == "" ] ; then
  TYPE="centos-7"
fi

pushd $COMMON_SCRIPT_DIR/.. > /dev/null
export OSSIM_DEV_HOME=`pwd -P`
export OSSIM_BUILD_DIR=$OSSIM_DEV_HOME/build
export OSSIM_INSTALL_PREFIX=$OSSIM_DEV_HOME/install
popd > /dev/null

if [ "MAKE_JOBS" == "" ] ;  then
   export MAKE_JOBS="-j4"
fi

if [ "${KAKADU_VERSION}" == "" ] ; then
   export KAKADU_VERSION="v7_7_1-01123C"
fi
if [ "$X264" == "" ] ; then
  export X264="x264-0.155-20180923-545de2f"
fi

if [ "$X265" == "" ] ; then
  export X265="x265_3.1.2"
fi

if [ "$SZIP" == "" ] ; then
  export SZIP="szip-2.1.1"
fi

if [ "$FFMPEG" == "" ] ; then
  export FFMPEG="ffmpeg-4.2"
fi

if [ "$JPEG12_TURBO" == "" ] ; then
  export JPEG12_TURBO="libjpeg12-turbo-1.4.2"
fi

if [ "$GPSTK" == "" ] ; then
  export GPSTK="gpstk-2.5"
fi

if [ "$AWS_SDK" == "" ] ; then
   export AWS_SDK="aws-sdk-cpp-1.0.29"
fi

if [ "$HDF5A" == "" ] ; then
   export HDF5A="hdf5a-1.8.17"
fi

if [ "$HDF5" == "" ] ; then
   export HDF5="hdf5-1.10.5"
fi

if [ "$OPENSCENEGRAPH" == "" ] ; then
   export OPENSCENEGRAPH="OpenSceneGraph-3.6.4"
fi

if [ "$SZIP" == "" ] ; then
   export SZIP="szip-2.1.1"
fi

if [ "$PROJ4" == "" ] ; then
   export PROJ4="proj-6.2.0"
fi

if [ "$GDAL" == "" ] ; then
   export GDAL="gdal-2.4.2"
fi

if [ -f /etc/os-release ] ; then
   source /etc/os-release
   export OS_ID=$ID
   export OS_ID_VERSION=$VERSION_ID
fi
