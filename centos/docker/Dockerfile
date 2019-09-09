FROM library/centos:7
ENV HOME=/home/ossim \
   JAVA_HOME=/usr/lib/jvm/java
RUN yum -y install epel-release && yum clean all&& \
   yum -y install git wget curl gcc tcsh\
   geos-devel gcc-c++ libtool ant\
   openssl-devel libjpeg-devel curl-devel nasm \
   libgeotiff-devel libtiff-devel sqlite-devel \
   libjpeg-devel libpng-devel swig \
   giflib-devel cmake numactl-devel cmake3 make jsoncpp-devel freetype-devel \
   lame-devel libvorbis-devel opus opus-devel libogg-devel librsvg2-devel libtheora-devel \
   libmodplug-devel libass-devel libbluray-devel libvpx-devel libvpx gnutls-devel gnutls openjpeg2-devel \
   fontconfig-devel xz-devel xz zlib-devel SDL2-devel mesa-libGL-devel mesa-libGLU-devel\
   java-1.8.0-openjdk-devel fribidi-devel speex-devel soxr-devel bzip2-devel bzip2 \
   yum clean all && \
   useradd -u 1001 -r -g 0 --create-home -d $HOME -s /sbin/nologin -c 'Default Build User' ossim && \
   rm -rf /usr/local/* && \
   chown -R 1001:0 /usr/local
USER 1001
