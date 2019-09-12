#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
BUILD_OSSIM_SCRIPT_DIR=`pwd -P`
popd >/dev/null

source $BUILD_OSSIM_SCRIPT_DIR/common.sh $1
if [ -f $OSSIM_DEV_HOME/ossim-deps-$TYPE-all.tgz ] ; then 
   cd /usr/local;tar xvfz $OSSIM_DEV_HOME/ossim-deps-$TYPE-all.tgz
   export OSSIM_DEPENDENCIES=/usr/local
else
   export OSSIM_DEPENDENCIES=$OSSIM_DEV_HOME/ossim-dependencies
fi

if [ -d $OSSIM_DEPENDENCIES ] ; then
   export LD_LIBRARY_PATH=$OSSIM_DEPENDENCIES/lib:$OSSIM_DEPENDENCIES:/lib64:$LD_LIBRARY_PATH
   export PATH=$OSSIM_DEPENDENCIES:/bin:$LD_LIBRARY_PATH
fi

rm -f $OSSIM_BUILD_DIR/CMakeCache.txt
export QTDIR=/usr
export BUILD_GEOPDF_PLUGIN=OFF 

export BUILD_HDF5_PLUGIN=ON
export BUILD_OSSIM_HDF5_SUPPORT=ON
export BUILD_KAKADU_PLUGIN=OFF

if [ -d /usr/local/kakadu ] ; then
   export KAKADU_ROOT_SRC=/usr/local/kakadu
   export KAKADU_LIBRARY=/usr/local/kakadu/lib/libkdu.a
   export KAKADU_AUX_LIBRARY=/usr/local/kakadu/lib/libkdu_aux.a
   export BUILD_KAKADU_PLUGIN=ON
elif [ -d $OSSIM_DEPENDENCIES/kakadu ] ; then
   export KAKADU_ROOT_SRC=$OSSIM_DEPENDENCIES/kakadu
   export KAKADU_LIBRARY=$KAKADU_ROOT_SRC/lib/libkdu.a
   export KAKADU_AUX_LIBRARY=$KAKADU_ROOT_SRC/lib/libkdu_aux.a
   export BUILD_KAKADU_PLUGIN=ON
fi
if [ -d $OSSIM_DEV_HOME/ossim-private/ossim-kakadu-jpip-server-new ] ; then
   export OSSIM_BUILD_ADDITIONAL_DIRECTORIES=$OSSIM_DEV_HOME/ossim-private/ossim-kakadu-jpip-server-new
fi
export BUILD_KML_PLUGIN=OFF
export BUILD_OSSIM_CURL_APPS=ON
export BUILD_JPEG12_PLUGIN=ON
export BUILD_MRSID_PLUGIN=OFF
export BUILD_OPENJPEG_PLUGIN=OFF
export BUILD_PDAL_PLUGIN=OFF
export BUILD_GDAL_PLUGIN=ON
export BUILD_PNG_PLUGIN=ON
export BUILD_WEB_PLUGIN=ON
export BUILD_AWS_PLUGIN=ON
export BUILD_OSSIM_PLANET_GUI=ON
export BUILD_CSM_PLUGIN=ON
export BUILD_GEOPDF_PLUGIN=ON
export BUILD_POTRACE_PLUGIN=ON
export BUILD_OSSIM_FRAMEWORKS=OFF
export BUILD_SQLITE_PLUGIN=ON
export BUILD_CNES_PLUGIN=ON
export BUILD_KML_PLUGIN=ON
export BUILD_OPENJPEG_PLUGIN=OFF
#export CMAKE_BUILD_TYPE=RelWithDebugInfo
if [ "$CMAKE_BUILD_TYPE" == "" ] ; then
export CMAKE_BUILD_TYPE=Release
fi
export BUILD_OPENCV_PLUGIN=OFF
export OSSIM_MAKE_JOBS=4

$OSSIM_DEV_HOME/ossim/scripts/build.sh
$OSSIM_DEV_HOME/ossim/scripts/install.sh

# REPOSITORY_MANAGER_URL=https://nexus.ossim.io/repository
# if [ -f $OSSIM_DEV_HOME/ossim-oms/joms/local.properties ] ; then
# cp $OSSIM_DEV_HOME/ossim-oms/joms/local.properties.template $OSSIM_DEV_HOME/ossim-oms/joms/local.properties 
# fi
# cd $OSSIM_DEV_HOME/ossim-oms/joms
# ant clean install

cp $OSSIM_INSTALL_PREFIX/share/ossim/ossim-preferences-template $OSSIM_INSTALL_PREFIX/share/ossim/ossim-site-preferences
if [ $? -ne 0 ]; then echo "ERROR: Failed build for OSSIM" ; exit 1 ; fi
pushd $OSSIM_DEV_HOME
tar cvfz ossim-$TYPE-all.tgz ossim-$TYPE-all
mkdir -p ossim-$TYPE-dev;
mkdir -p ossim-$TYPE-runtime;
cp -R ossim-$TYPE-all/include ossim-$TYPE-dev/
cp -R ossim-$TYPE-all/lib ossim-$TYPE-dev/
cp -R ossim-$TYPE-all/lib64 ossim-$TYPE-dev/
cp -R ossim-$TYPE-all/bin ossim-$TYPE-runtime/
cp -R ossim-$TYPE-all/lib64 ossim-$TYPE-runtime/
cp -R ossim-$TYPE-all/share ossim-$TYPE-runtime/
cd ossim-$TYPE-dev
tar cvfz $OSSIM_DEV_HOME/ossim-$TYPE-dev.tgz *
cd $OSSIM_DEV_HOME/ossim-$TYPE-runtime
tar cvfz $OSSIM_DEV_HOME/ossim-$TYPE-runtime.tgz *
popd

exit 0