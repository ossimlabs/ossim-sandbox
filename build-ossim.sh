#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
BUILD_OSSIM_SCRIPT_DIR=`pwd -P`
popd >/dev/null

echo "SOURCING: $BUILD_OSSIM_SCRIPT_DIR/common.sh $1"
source $BUILD_OSSIM_SCRIPT_DIR/common.sh $1
echo "MAVEN_DOWNLOAD_URL      = $MAVEN_DOWNLOAD_URL"
echo "REPOSITORY_MANAGER_URL  = ${REPOSITORY_MANAGER_URL}"
echo "OSSIM_DEV_HOME          = $OSSIM_DEV_HOME"

if [ -f $OSSIM_DEV_HOME/ossim-deps-$TYPE-all.tgz ] ; then
   cd /usr/local
   tar xvfz $OSSIM_DEV_HOME/ossim-deps-$TYPE-all.tgz
   export OSSIM_DEPENDENCIES=/usr/local
else
   export OSSIM_DEPENDENCIES=$OSSIM_DEV_HOME/ossim-dependencies
fi

if [ -f $OSSIM_DEV_HOME/qt4-${TYPE}.tgz ]; then
   echo; echo "*** Building with QT4 ***"; echo
   pushd $OSSIM_DEPENDENCIES;
   tar xvf $OSSIM_DEV_HOME/qt4-${TYPE}.tgz
   popd
   export BUILD_OSSIM_QT4=ON
   export QT_BINARY_DIR=$OSSIM_DEPENDENCIES/bin
fi

echo "OSSIM_DEPENDENCIES      = $OSSIM_DEPENDENCIES"
if [ -d $OSSIM_DEPENDENCIES ] ; then
   export LD_LIBRARY_PATH=$OSSIM_DEPENDENCIES/lib:$OSSIM_DEPENDENCIES/lib64:$LD_LIBRARY_PATH
   export PATH=$OSSIM_DEPENDENCIES:/bin:$PATH
fi
mkdir -p $OSSIM_BUILD_DIR
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
export BUILD_OSSIM_MPI_SUPPORT=ON

#export CMAKE_BUILD_TYPE=RelWithDebugInfo
if [ "$CMAKE_BUILD_TYPE" == "" ] ; then
export CMAKE_BUILD_TYPE=Release
fi
export BUILD_OPENCV_PLUGIN=OFF
echo "OSSIM_DEV_HOME        = ${OSSIM_DEV_HOME}"
echo "OSSIM_BUILD_DIR        = ${OSSIM_BUILD_DIR}"
echo "OSSIM_INSTALL_PREFIX        = ${OSSIM_INSTALL_PREFIX}"
$OSSIM_DEV_HOME/ossim/scripts/build.sh
$OSSIM_DEV_HOME/ossim/scripts/install.sh

$OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux/build.sh
$OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux/install.sh

cp $OSSIM_INSTALL_PREFIX/share/ossim/ossim-preferences-template $OSSIM_INSTALL_PREFIX/share/ossim/ossim-site-preferences
if [ $? -ne 0 ]; then echo "ERROR: Failed build for OSSIM" ; exit 1 ; fi
pushd $OSSIM_DEV_HOME/ossim-$TYPE-all
tar cvfz $ROOT_DIR/ossim-$TYPE-all.tgz *
popd

mkdir -p $OSSIM_DEV_HOME/ossim-$TYPE-dev;
mkdir -p $OSSIM_DEV_HOME/ossim-$TYPE-runtime;
cp -R $OSSIM_DEV_HOME/ossim-$TYPE-all/include $OSSIM_DEV_HOME/ossim-$TYPE-dev/
cp -R $OSSIM_DEV_HOME/ossim-$TYPE-all/lib $OSSIM_DEV_HOME/ossim-$TYPE-dev/
cp -R $OSSIM_DEV_HOME/ossim-$TYPE-all/lib64 $OSSIM_DEV_HOME/ossim-$TYPE-dev/
cp -R $OSSIM_DEV_HOME/ossim-$TYPE-all/share $OSSIM_DEV_HOME/ossim-$TYPE-dev/
cp -R $OSSIM_DEV_HOME/ossim-$TYPE-all/bin $OSSIM_DEV_HOME/ossim-$TYPE-runtime/
cp -R $OSSIM_DEV_HOME/ossim-$TYPE-all/lib64 $OSSIM_DEV_HOME/ossim-$TYPE-runtime/
cp -R $OSSIM_DEV_HOME/ossim-$TYPE-all/share $OSSIM_DEV_HOME/ossim-$TYPE-runtime/

pushd $OSSIM_DEV_HOME/ossim-$TYPE-dev
tar cvfz $ROOT_DIR/ossim-$TYPE-dev.tgz *
popd

pushd $OSSIM_DEV_HOME/ossim-$TYPE-runtime
tar cvfz $ROOT_DIR/ossim-$TYPE-runtime.tgz *
popd

$OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux/build.sh
if [ $? -ne 0 ]; then
   echo; echo "ERROR: Build failed for joms."
   exit 1
fi
$OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux/install.sh
if [ $? -ne 0 ]; then
   echo; echo "ERROR: Install failed for joms."
   exit 1
fi

export LD_LIBRARY_PATH=$OSSIM_INSTALL_PREFIX/lib64:$OSSIM_INSTALL_PREFIX/lib:$LD_LIBRARY_PATH

echo "************************** Creating Runtime Sandbox ***************************"
export SANDBOX_NAME=ossim-sandbox-$TYPE-runtime
export SANDBOX_DIR=$OSSIM_DEV_HOME/$SANDBOX_NAME
mkdir -p $SANDBOX_DIR
mkdir -p $SANDBOX_DIR/bin
mkdir -p $SANDBOX_DIR/lib64
mkdir -p $SANDBOX_DIR/lib


# $OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $TEMP_EXTRACT_DIR/lib64 $SANDBOX_DIR
cp -R $OSSIM_INSTALL_PREFIX/lib64/* $SANDBOX_DIR/lib64;
# cp -R $OSSIM_DEPENDENCIES/lib/* $SANDBOX_DIR/lib64/;
# cp -R $OSSIM_DEPENDENCIES/lib64/* $SANDBOX_DIR/lib64/;
cp -R $OSSIM_INSTALL_PREFIX/share $SANDBOX_DIR/;
cp -R $OSSIM_DEPENDENCIES/share $SANDBOX_DIR/;
cp $OSSIM_DEPENDENCIES/bin/gdal* $SANDBOX_DIR/bin/;
cp $OSSIM_DEPENDENCIES/bin/ff* $SANDBOX_DIR/bin/;
cp $OSSIM_DEPENDENCIES/bin/listgeo $SANDBOX_DIR/bin/;
cp -R $OSSIM_INSTALL_PREFIX/bin $SANDBOX_DIR/;
rm -rf $SANDBOX_DIR/bin/ossim-*test
rm -f $SANDBOX_DIR/lib64/*.a

$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossim.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/liboms.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossim-wms.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossim-video.so $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/ossim/plugins $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/bin $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_DEPENDENCIES/bin $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_DEPENDENCIES/lib $SANDBOX_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_DEPENDENCIES/lib64 $SANDBOX_DIR/lib64

if [ -f $OSSIM_INSTALL_PREFIX/lib64/libossimQt.so ]; then
   $OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossimQt.so $SANDBOX_DIR/lib64
fi

chmod +x $SANDBOX_DIR/bin/*
chmod +x $SANDBOX_DIR/lib64/*

pushd $SANDBOX_DIR
tar cvfz $ROOT_DIR/$SANDBOX_NAME.tgz *
popd

pushd $OSSIM_DEV_HOME/ossim-oms/joms

   if "$DEPLOY_JOMS" ; then
      gradle uploadArchives
      if [ $? -ne 0 ]; then
      echo; echo "ERROR: Build failed for JOMS Deploy to Nexus."
      exit 1
      fi
   fi
popd

echo "************************** Creating Runtime Slim Docker ***************************"
export SLIM_NAME=ossim-docker-slim-$TYPE-runtime
export SLIM_DIR=$OSSIM_DEV_HOME/$SLIM_NAME
mkdir -p $SLIM_DIR
mkdir -p $SLIM_DIR/bin
mkdir -p $SLIM_DIR/lib64
mkdir -p $SLIM_DIR/lib


# $OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $TEMP_EXTRACT_DIR/lib64 $SANDBOX_DIR
cp -R $OSSIM_INSTALL_PREFIX/lib64/* $SLIM_DIR/lib64;
# cp -R $OSSIM_DEPENDENCIES/lib/* $SANDBOX_DIR/lib64/;
# cp -R $OSSIM_DEPENDENCIES/lib64/* $SANDBOX_DIR/lib64/;
cp -R $OSSIM_INSTALL_PREFIX/share $SLIM_DIR/;
cp -R $OSSIM_DEPENDENCIES/share $SLIM_DIR/;
cp $OSSIM_DEPENDENCIES/bin/gdal* $SLIM_DIR/bin/;
cp $OSSIM_DEPENDENCIES/bin/ff* $SLIM_DIR/bin/;
cp $OSSIM_DEPENDENCIES/bin/listgeo $SLIM_DIR/bin/;
cp -R $OSSIM_INSTALL_PREFIX/bin $SLIM_DIR/;
rm -rf $SLIM_DIR/bin/ossim-*test
rm -f $SLIM_DIR/lib64/*.a

$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossim.so $SLIM_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/liboms.so $SLIM_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossim-wms.so $SLIM_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossim-video.so $SLIM_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/ossim/plugins $SLIM_DIR/lib64
$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/bin $SLIM_DIR/lib64
#$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_DEPENDENCIES/bin $SLIM_DIR/lib64
#$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_DEPENDENCIES/lib $SLIM_DIR/lib64
#$OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_DEPENDENCIES/lib64 $SLIM_DIR/lib64

if [ -f $OSSIM_INSTALL_PREFIX/lib64/libossimQt.so ]; then
   $OSSIM_DEV_HOME/ossim/scripts/ocpld.sh $OSSIM_INSTALL_PREFIX/lib64/libossimQt.so $SLIM_DIR/lib64
fi

chmod +x $SLIM_DIR/bin/*
chmod +x $SLIM_DIR/lib64/*

pushd $SLIM_DIR
tar cvfz $ROOT_DIR/$SLIM_NAME.tgz *
popd

pushd $OSSIM_DEV_HOME/ossim-oms/joms

   if "$DEPLOY_JOMS" ; then
      gradle uploadArchives
      if [ $? -ne 0 ]; then
      echo; echo "ERROR: Build failed for JOMS Deploy to Nexus."
      exit 1
      fi
   fi
popd
exit 0