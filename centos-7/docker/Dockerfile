FROM library/centos:7
ARG GRADLE_VERSION=4.10.2
ARG GROOVY_VERSION=2.4.15
ENV HOME=/home/ossim \
   JAVA_HOME=/usr/lib/jvm/java \
   GRADLE_HOME=/usr/gradle\
   GROOVY_HOME=/usr/groovy\
   PATH=/usr/bin:/usr/local/bin:/usr/gradle/bin:$PATH

RUN yum -y install epel-release && yum clean all&& \
   yum -y install git wget curl gcc tcsh gcc-c++ libtool ant \
   openssl-devel libjpeg-devel curl-devel nasm \
   libtiff-devel sqlite-devel libpng-devel swig libjpeg-turbo-devel podofo-devel\
   giflib-devel cmake numactl-devel cmake3 make jsoncpp-devel freetype-devel \
   lame-devel libvorbis-devel opus opus-devel libogg-devel librsvg2-devel libtheora-devel \
   libmodplug-devel libass-devel libbluray-devel libvpx-devel libvpx gnutls-devel gnutls openjpeg2-devel \
   fontconfig-devel xz-devel xz zlib-devel SDL2-devel mesa-libGL-devel mesa-libGLU-devel\
   java-1.8.0-openjdk-devel fribidi-devel speex-devel soxr-devel bzip2-devel bzip2 \ \
   qt5-qtbase-devel minizip-devel chrpath unzip maven\
   yum clean all && \
   useradd -u 1001 -r -g 0 --create-home -d $HOME -s /sbin/nologin -c 'Default Build User' ossim && \
   rm -rf /usr/local/* && \
   chmod -R 777 /usr/local && \
   chmod  777 /home/ossim
RUN curl -L https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -o /usr/gradle-$GRADLE_VERSION-bin.zip; \
   curl -L https://archive.apache.org/dist/groovy/$GROOVY_VERSION/distribution/apache-groovy-binary-$GROOVY_VERSION.zip -o /usr/apache-groovy-binary-$GROOVY_VERSION.zip; \
   cd /usr;unzip gradle-$GRADLE_VERSION-bin.zip;unzip apache-groovy-binary-$GROOVY_VERSION.zip; \
   ln -s gradle-$GRADLE_VERSION gradle; ln -s groovy-$GROOVY_VERSION groovy;rm -f /usr/*.zip
USER 1001
