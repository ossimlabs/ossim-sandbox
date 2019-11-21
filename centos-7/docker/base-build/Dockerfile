FROM centos:7
ARG GRADLE_VERSION=5.6.4
ARG GROOVY_VERSION=2.5.8
ARG GRAILS_VERSION=4.0.1
ENV HOME=/home/jenkins \
   JAVA_HOME=/usr/lib/jvm/java \
   JRE_HOME=/usr/lib/jvm/jre \
   GRADLE_HOME=/usr/gradle\
   GROOVY_HOME=/usr/groovy\
   PATH=/usr/bin:/usr/local/bin:/usr/groovy/bin:/usr/gradle/bin:/usr/grails/bin:$PATH

RUN yum -y install epel-release && yum clean all&& \
   yum -y install git wget curl gcc tcsh gcc-c++ libtool ant \
   openssl-devel libjpeg-devel curl-devel nasm mpich-3.2-devel \
   libtiff-devel sqlite-devel libpng-devel swig libjpeg-turbo-devel podofo-devel\
   giflib-devel cmake numactl-devel cmake3 make jsoncpp-devel freetype-devel \
   lame-devel libvorbis-devel opus opus-devel libogg-devel librsvg2-devel libtheora-devel \
   libmodplug-devel libass-devel libbluray-devel libvpx-devel libvpx gnutls-devel gnutls openjpeg2-devel \
   fontconfig-devel xz-devel xz zlib-devel SDL2-devel mesa-libGL-devel mesa-libGLU-devel\
   java-1.8.0-openjdk-devel fribidi-devel speex-devel soxr-devel bzip2-devel bzip2 \
   qt5-qtbase-devel minizip-devel chrpath unzip maven sudo awscli\
   yum clean all && \
   rm -rf /usr/local/* && \
   chmod -R 777 /usr/local 
RUN curl -L https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -o /usr/gradle-$GRADLE_VERSION-bin.zip; \
   curl -L https://archive.apache.org/dist/groovy/$GROOVY_VERSION/distribution/apache-groovy-binary-$GROOVY_VERSION.zip -o /usr/apache-groovy-binary-$GROOVY_VERSION.zip; \
   curl -L https://github.com/grails/grails-core/releases/download/v$GRAILS_VERSION/grails-$GRAILS_VERSION.zip -o /usr/grails-$GRAILS_VERSION.zip ; \
   cd /usr;unzip gradle-$GRADLE_VERSION-bin.zip;unzip apache-groovy-binary-$GROOVY_VERSION.zip; \
   unzip grails-$GRAILS_VERSION-bin.zip; \
   ln -s gradle-$GRADLE_VERSION gradle; ln -s grails-$GRAILS_VERSION grails; ln -s groovy-$GROOVY_VERSION groovy;rm -f /usr/*.zip

# Add a dedicated jenkins system user
RUN useradd -u 1001 -g 0 --system --shell /bin/bash --create-home --home /home/jenkins jenkins; \
    chmod  777 /home/jenkins

# Switch to user `jenkins`
USER jenkins


WORKDIR /home/jenkins
