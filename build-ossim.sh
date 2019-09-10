#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
BUILD_OSSIM_SCRIPT_DIR=`pwd -P`
popd >/dev/null

source $BUILD_OSSIM_SCRIPT_DIR/common.sh


rm -f $OSSIM_BUILD_DIR/CMakeCache.txt
export QTDIR=/usr/local/opt/qt5
export Qt5Widgets_DIR=$QTDIR/lib/cmake/Qt5Widgets
export Qt5Core_DIR=$QTDIR/lib/cmake/Qt5Core
export Qt5OpenGL_DIR=$QTDIR/lib/cmake/Qt5OpenGL
export BUILD_GEOPDF_PLUGIN=OFF 

export BUILD_HDF5_PLUGIN=ON
export BUILD_OSSIM_HDF5_SUPPORT=ON
export KAKADU_ROOT_SRC=$OSSIM_DEPENDENCIES/kakadu
export KAKADU_LIBRARY=$OSSIM_DEPENDENCIES/kakadu/lib/libkdu.a
export KAKADU_AUX_LIBRARY=$OSSIM_DEPENDENCIES/kakadu/lib/libkdu_aux.a
export BUILD_KML_PLUGIN=OFF
export BUILD_OSSIM_CURL_APPS=ON
export BUILD_JPEG12_PLUGIN=OFF
export BUILD_MRSID_PLUGIN=OFF
export MRSID_DIR=$OSSIM_DEPENDENCIES/MrSID_DSDK-9.0.0.3864-darwin12.universal.gccA42 \
export BUILD_OPENJPEG_PLUGIN=OFF
export BUILD_PDAL_PLUGIN=OFF
export BUILD_GDAL_PLUGIN=ON
export BUILD_PNG_PLUGIN=ON
export BUILD_WEB_PLUGIN=ON
export BUILD_AWS_PLUGIN=ON
export BUILD_OSSIM_PLANET_GUI=ON
export BUILD_CSM_PLUGIN=OFF
export BUILD_KAKADU_PLUGIN=ON
export BUILD_GEOPDF_PLUGIN=ON
export BUILD_POTRACE_PLUGIN=ON
export BUILD_OSSIM_FRAMEWORKS=ON
export BUILD_SQLITE_PLUGIN=ON
export BUILD_CNES_PLUGIN=ON
export BUILD_KML_PLUGIN=ON
export BUILD_OPENJPEG_PLUGIN=OFF
export OSSIM_BUILD_ADDITIONAL_DIRECTORIES=$OSSIM_DEV_HOME/ossim-private/ossim-kakadu-jpip-server
#export CMAKE_BUILD_TYPE=RelWithDebugInfo
export CMAKE_BUILD_TYPE=Debug
export BUILD_OPENCV_PLUGIN=OFF
export OSSIM_MAKE_JOBS=12


$OSSIM_DEV_HOME/ossim/scripts/build.sh
if [ $? -ne 0 ]; then echo "ERROR: Failed build for OSSIM" ; exit 1 ; fi
exit 0