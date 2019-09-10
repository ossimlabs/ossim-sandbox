#!/bin/bash
pushd `dirname ${BASH_SOURCE[0]}` >/dev/null
BUILD_OSSIM_DEPS_DIR=`pwd -P`
popd >/dev/null

source $BUILD_OSSIM_DEPS_DIR/common.sh $1

#
# Print out all version we are building
# 
echo "MAKE_JOBS        = $MAKE_JOBS"
echo "KAKADU_VERSION   = $KAKADU_VERSION"
echo "X264             = $X264"
echo "SZIP             = $SZIP"
echo "X265             = $X265"
echo "GEOS             = $GEOS"
echo "GEOTIFF          = $GEOTIFF"
echo "FFMPEG           = $FFMPEG"
echo "JPEG12_TURBO     = $JPEG12_TURBO"
echo "GPSTK            = $GPSTK"
echo "AWS_SDK          = $AWS_SDK"
echo "HDF5             = $HDF5"
echo "OPENSCENEGRAPH   = $OPENSCENEGRAPH"
echo "SZIP             = $SZIP"
echo "PROJ4            = $PROJ4"
echo "OS_ID            = $OS_ID"
echo "OS_ID_VERSION    = $OS_ID_VERSION"

#
# Setup szip
#
if [ ! -d $OSSIM_DEV_HOME/$SZIP ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$SZIP.tgz -O $SZIP.tgz
  tar xvfz $SZIP.tgz
  rm -f $SZIP.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$SZIP ] ; then
   cd $OSSIM_DEV_HOME/$SZIP
   mkdir -p build
   cd build
#   cmake3 -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ..
   cmake3 -DCMAKE_BUILD_TYPE=Release ..
   make $MAKE_JOBS install
   if [ $? -ne 0 ]; then echo "szip install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$SZIP Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup kakadu
#
if [ -d $OSSIM_DEV_HOME/ossim-private ] ; then
   export CXXFLAGS=-fPIC
   cd $OSSIM_DEV_HOME/ossim-private/kakadu/${KAKADU_VERSION}/make
   make -f ./Makefile-Linux-x86-64-gcc
   if [ $? -ne 0 ]; then echo "kakadu build erro: $error" ; exit 1 ; fi
   unset CXXFLAGS
   cd $OSSIM_DEV_HOME/ossim-private/kakadu/${KAKADU_VERSION}/lib
   ln -s Linux-x86-64-gcc/lib* .
   mkdir -p /usr/local/kakadu/managed/all_includes
   mkdir -p /usr/local/kakadu/lib
   mkdir -p /usr/local/kakadu/bin
   cp -R $OSSIM_DEV_HOME/ossim-private/kakadu/${KAKADU_VERSION}/managed/all_includes/* /usr/local/kakadu/managed/all_includes
   cp -R $OSSIM_DEV_HOME/ossim-private/kakadu/${KAKADU_VERSION}/lib/Linux-x86-64-gcc/* /usr/local/kakadu/lib/ 
   cp -R $OSSIM_DEV_HOME/ossim-private/kakadu/${KAKADU_VERSION}/bin/Linux-x86-64-gcc/* /usr/local/kakadu/bin/ 
fi

#
# Setup X264
#
if [ ! -d $OSSIM_DEV_HOME/$X264 ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$X264.tgz -O $X264.tgz
  tar xvfz $X264.tgz
  rm -f $X264.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$X264 ] ; then
   cd $OSSIM_DEV_HOME/$X264
   ./configure --enable-shared --prefix=/usr/local --disable-asm
   make $MAKE_JOBS install install-lib-static install-lib-shared
   if [ $? -ne 0 ]; then echo "x264 install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$X264 Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup X265
#
if [ ! -d $OSSIM_DEV_HOME/$X265 ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$X265.tgz -O $X265.tgz
  tar xvfz $X265.tgz
  rm -f $X265.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$X265 ] ; then
   cd $OSSIM_DEV_HOME/$X265/build/linux
   cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ../../source 
   make $MAKE_JOBS VERBOSE=true install
   if [ $? -ne 0 ]; then echo "x265 make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$X265.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup PROJ4
#
if [ ! -d $OSSIM_DEV_HOME/$PROJ4 ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$PROJ4.tgz -O $PROJ4.tgz
  tar xvfz $PROJ4.tgz
  rm -f $PROJ4.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$PROJ4 ] ; then
   cd $OSSIM_DEV_HOME/$PROJ4
   mkdir build
   cd build
   cmake3 -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. 
   make $MAKE_JOBS VERBOSE=true install
   if [ $? -ne 0 ]; then echo "proj4 make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$PROJ4.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup szip
#
if [ ! -d $OSSIM_DEV_HOME/$SZIP ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$SZIP.tgz -O $SZIP.tgz
  tar xvfz $SZIP.tgz
  rm -f $SZIP.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$SZIP ] ; then
   export SZIP_INSTALL=/usr/local

   cd $OSSIM_DEV_HOME/$SZIP
   mkdir build
   cd build
   cmake3 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$SZIP_INSTALL .. 
   make $MAKE_JOBS VERBOSE=true install
   if [ $? -ne 0 ]; then echo "szip make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$SZIP.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup libjpeg12-turbo
#
if [ ! -d $OSSIM_DEV_HOME/$JPEG12_TURBO ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$JPEG12_TURBO.tgz -O $JPEG12_TURBO.tgz
  tar xvfz $JPEG12_TURBO.tgz
  rm -f $JPEG12_TURBO.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$JPEG12_TURBO ] ; then
   cd $OSSIM_DEV_HOME/$JPEG12_TURBO
   autoreconf -fiv
   ./configure --prefix=/usr/local --disable-static --with-12bit --with-jpeg8
   make $MAKE_JOBS install
   if [ $? -ne 0 ]; then echo "jpeg12 turbo make install: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$JPEG12_TURBO.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi


#
# Setup FFMPEG
#
if [ ! -d $OSSIM_DEV_HOME/$FFMPEG ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$FFMPEG.tgz -O $FFMPEG.tgz
  tar xvfz $FFMPEG.tgz
  rm -f $FFMPEG.tgz
fi

if [ -d $OSSIM_DEV_HOME/$FFMPEG ] ; then
   cd $OSSIM_DEV_HOME/$FFMPEG
   ./configure --prefix=/usr/local \
               --enable-swscale --enable-avfilter --enable-avresample \
               --enable-libmp3lame --enable-libvorbis \
               --enable-librsvg --enable-libtheora --enable-libopenjpeg \
               --enable-libmodplug --enable-libsoxr \
               --enable-libspeex --enable-libass --enable-libbluray \
               --enable-lzma --enable-gnutls --enable-fontconfig --enable-libfreetype \
               --enable-libfribidi --disable-libjack --disable-libopencore-amrnb \
               --disable-libopencore-amrwb --disable-libxcb --disable-libxcb-shm --disable-libxcb-xfixes \
               --disable-indev=jack --disable-outdev=xv\
               --enable-sdl2 --disable-securetransport --mandir=/usr/local/share/man \
               --enable-shared --enable-pthreads --arch=x86_64 --enable-x86asm \
               --enable-gpl --enable-postproc --enable-libx264 
   make $MAKE_JOBS install
   if [ $? -ne 0 ]; then echo "ffmpeg make install error: $error" ; exit 1 ; fi

else
   echo "Error: $OSSIM_DEV_HOME/$FFMPEG Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
fi

#
# Setup hdf5
#
if [ ! -d $OSSIM_DEV_HOME/$HDF5 ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$HDF5.tgz -O $HDF5.tgz
  tar xvfz $HDF5.tgz
  rm -f $HDF5.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$HDF5 ] ; then
   cd $OSSIM_DEV_HOME/$HDF5
   mkdir -p build
   cd build
   cmake3 \
   -DCMAKE_INSTALL_PREFIX=/usr/local \
   -DSZIP_LIBRARY=/usr/local/lib/libszip.a \
   -DSZIP_INCLUDE_DIR=/usr/local/include \
   -DSZIP_DIR=/usr/local \
   -DBUILD_TESTING=OFF \
   -DCMAKE_BUILD_TYPE=Release \
   -DHDF5_BUILD_CPP_LIB=ON \
   -DHDF5_BUILD_EXAMPLES=OFF \
   -DHDF5_BUILD_FORTRAN=OFF \
   -DHDF5_BUILD_HL_LIB=OFF \
   -DHDF5_BUILD_TOOLS=OFF \
   -DHDF5_ENABLE_Z_LIB_SUPPORT=ON \
   -DHDF5_ENABLE_SZIP_SUPPORT=ON \
   ..

   make VERBOSE=1 $MAKE_JOBS install
   if [ $? -ne 0 ]; then echo "hdf5 make install error: $error" ; exit 1 ; fi
 
else
   echo "Error: $OSSIM_DEV_HOME/$HDF5.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup aws sdk
#
if [ ! -d $OSSIM_DEV_HOME/$AWS_SDK ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$AWS_SDK.tgz -O $AWS_SDK.tgz
  tar xvfz $AWS_SDK.tgz
  rm -f $AWS_SDK.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$AWS_SDK ] ; then
   cd $OSSIM_DEV_HOME/$AWS_SDK
   mkdir -p build
   cd build
   cmake3 .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_TESTING=OFF -DBUILD_ONLY="s3;sqs;sns;cognito-identity"
   make $MAKE_JOBS VERBOSE=1 install
   if [ $? -ne 0 ]; then echo "aws sdk make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$AWS_SDK.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

if [ ! -d $OSSIM_DEV_HOME/$GEOS ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$GEOS.tgz -O $GEOS.tgz
  tar xvfz $GEOS.tgz
  rm -f $GEOS.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$GEOS ] ; then
   cd $OSSIM_DEV_HOME/$GEOS
   mkdir -p build
   cd build
   cmake3 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
   make $MAKE_JOBS VERBOSE=1 install
   if [ $? -ne 0 ]; then echo "geos make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$GEOS.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

if [ ! -d $OSSIM_DEV_HOME/$GEOTIFF ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$GEOTIFF.tgz -O $GEOTIFF.tgz
  tar xvfz $GEOTIFF.tgz
  rm -f $GEOTIFF.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$GEOTIFF ] ; then
   cd $OSSIM_DEV_HOME/$GEOTIFF
   mkdir -p build
   cd build
   cmake3 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
   make $MAKE_JOBS VERBOSE=1 install
   if [ $? -ne 0 ]; then echo "geotff make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$GEOTIFF.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup gdal
#
if [ ! -d $OSSIM_DEV_HOME/$GDAL ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$GDAL.tgz -O $GDAL.tgz
  tar xvfz $GDAL.tgz
  rm -f $GDAL.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$GDAL ] ; then
   cd $OSSIM_DEV_HOME/$GDAL
   ./configure --with-kakadu=$OSSIM_DEV_HOME/ossim-private/kakadu/$KAKADU_VERSION --with-proj=/usr/local --with-jpeg=internal --prefix=/usr/local --enable-shared --disable-static 
   make $MAKE_JOBS install
   if [ $? -ne 0 ]; then echo "gdal make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$AWS_SDK.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup gpstk
#
if [ ! -d $OSSIM_DEV_HOME/$GPSTK ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$GPSTK.tgz -O $GPSTK.tgz
  tar xvfz $GPSTK.tgz
  rm -f $GPSTK.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$GPSTK ] ; then
   cd $OSSIM_DEV_HOME/$GPSTK
   mkdir -p build
   cd build
   cmake ../dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
   make VERBOSE=1 $MAKE_JOBS install
   if [ $? -ne 0 ]; then echo "gpstk make install error: $error" ; exit 1 ; fi
else
   echo "Error: $OSSIM_DEV_HOME/$GPSTK.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1  
fi

#
# Setup hdf5a
#
# if [ ! -d $OSSIM_DEV_HOME/$HDF5A ] ; then
#   pushd $OSSIM_DEV_HOME
#   wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$HDF5A.tgz -O $HDF5A.tgz
#   tar xvfz $HDF5A.tgz
#   popd > /dev/null
# fi

# if [ -d $OSSIM_DEV_HOME/$HDF5A ] ; then
#    cd $OSSIM_DEV_HOME/$HDF5A
#    mkdir -p build
#    cd build
#    cmake3 \
#    -DCMAKE_INSTALL_PREFIX=/usr/local \
#    -DSZIP_LIBRARY=/usr/local/lib/libszip.a \
#    -DSZIP_INCLUDE_DIR=/usr/local/include \
#    -DSZIP_DIR=/usr/local \
#    -DBUILD_SHARED_LIBS=ON \
#    -DBUILD_TESTING=OFF \
#    -DHDF5_BINARY_DIR=/usr/local/lib64 \
#    -DCMAKE_BUILD_TYPE=Release \
#    -DHDF5_BUILD_CPP_LIB=ON \
#    -DHDF5_BUILD_EXAMPLES=OFF \
#    -DHDF5_BUILD_FORTRAN=OFF \
#    -DHDF5_BUILD_HL_LIB=OFF \
#    -DHDF5_BUILD_TOOLS=OFF \
#    -DHDF5_ENABLE_Z_LIB_SUPPORT=ON \
#    -DHDF5_ENABLE_SZIP_SUPPORT=ON \
#    -DHDF5_INSTALL_LIB_DIR=/usr/lib64 \
#    ..
#    make VERBOSE=1 $MAKE_JOBS install DESTDIR=$OSSIM_DEV_HOME/$HDF5A/build/install
#    if [ $? -ne 0 ]; then echo "hdf5A make install error: $error" ; exit 1 ; fi
# else
#    echo "Error: $OSSIM_DEV_HOME/$HDF5A.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
#    exit 1  
# fi


#
# Setup OpenSceneGraph
#
if [ ! -d $OSSIM_DEV_HOME/$OPENSCENEGRAPH ] ; then
  pushd $OSSIM_DEV_HOME
  wget -q https://s3.amazonaws.com/ossimlabs/dependencies/source/$OPENSCENEGRAPH.tgz -O $OPENSCENEGRAPH.tgz
  tar xvfz $OPENSCENEGRAPH.tgz
  rm -f $OPENSCENEGRAPH.tgz
  popd > /dev/null
fi

if [ -d $OSSIM_DEV_HOME/$OPENSCENEGRAPH ] ; then
   cd $OSSIM_DEV_HOME/$OPENSCENEGRAPH
   mkdir -p build
   cd build
   CFLAGS="-pthread"
   CXXFLAGS="-pthread -std=c++11"
   cmake \
      -DBUILD_OSG_EXAMPLES=OFF \
      -DBUILD_DOCUMENTATION=OFF \
      .. -Wno-dev
   make $MAKE_JOBS VERBOSE=1 install
   if [ $? -ne 0 ] ; then echo "OpenSceneGraph make install error: $error" ; exit 1 ; fi
   unset CFLAGS
   unset CXXFLAGS
else
   echo "Error: $OSSIM_DEV_HOME/$OPENSCENEGRAPH.tgz Not found.  Please edit the common.sh to specify the proper version then place the version under https://s3.amazonaws.com/ossimlabs/dependencies/source/"
   exit 1
fi

echo "Packaging dependencies........"
cd /usr/local
tar cvfz $OSSIM_DEV_HOME/ossim-deps-$TYPE-all.tgz *
tar cvfz $OSSIM_DEV_HOME/ossim-deps-$TYPE-runtime.tgz bin lib lib64 share kakadu/lib kakadu/bin
tar cvfz $OSSIM_DEV_HOME/ossim-deps-$TYPE-dev.tgz include lib lib64 kakadu/lib kakadu/managed
exit 0
