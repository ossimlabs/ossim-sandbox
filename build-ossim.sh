#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
BUILD_OSSIM_SCRIPT_DIR=`pwd -P`
popd >/dev/null

source $BUILD_OSSIM_SCRIPT_DIR/common.sh $1
export OSSIM_DEPENDENCIES=$OSSIM_DEV_HOME/ossim-dependencies

rm -f $OSSIM_BUILD_DIR/CMakeCache.txt
#export QTDIR=/usr/local/opt/qt5
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
export BUILD_OSSIM_CURL_APPS=OFF
export BUILD_JPEG12_PLUGIN=ON
export BUILD_MRSID_PLUGIN=OFF
export BUILD_OPENJPEG_PLUGIN=OFF
export BUILD_PDAL_PLUGIN=OFF
export BUILD_GDAL_PLUGIN=ON
export BUILD_PNG_PLUGIN=ON
export BUILD_WEB_PLUGIN=ON
export BUILD_AWS_PLUGIN=ON
export BUILD_OSSIM_PLANET_GUI=OFF
export BUILD_CSM_PLUGIN=OFF
export BUILD_KAKADU_PLUGIN=ON
export BUILD_GEOPDF_PLUGIN=OFF
export BUILD_POTRACE_PLUGIN=OFF
export BUILD_OSSIM_FRAMEWORKS=OFF
export BUILD_SQLITE_PLUGIN=OFF
export BUILD_CNES_PLUGIN=OFF
export BUILD_KML_PLUGIN=OFF
export BUILD_OPENJPEG_PLUGIN=OFF
export OSSIM_BUILD_ADDITIONAL_DIRECTORIES=$OSSIM_DEV_HOME/ossim-private/ossim-kakadu-jpip-server
#export CMAKE_BUILD_TYPE=RelWithDebugInfo
export CMAKE_BUILD_TYPE=Release
export BUILD_OPENCV_PLUGIN=OFF
export OSSIM_MAKE_JOBS=4

export OSSIM_INSTALL_PREFIX=$OSSIM_DEPENDENCIES/ossim-$TYPE-all
$OSSIM_DEV_HOME/ossim/scripts/build.sh
if [ $? -ne 0 ]; then echo "ERROR: Failed build for OSSIM" ; exit 1 ; fi
tar cvfz $OSSIM_DEPENDENCIES/ossim-$TYPE-all.tgz
exit 0