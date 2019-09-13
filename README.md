# OSSIM Sandbox

This repo has 3 jenkins pipelines for doing different stages in the build process.  The first stage is creating the image used to build everything, next is to build the dependencies, and the third is to build OSSIM.  The build image is a jenkins artifact and stays with the branch it was built for.

The OSSIM sandbox repo is responsible for the following:

- Creating the build image with all the requirements to build the ossim dependencies and OSSIM

- Build the OSSIM dependencies which include echo Kakadu, X264, GEOS, SZIP, GeoTIFF, 
  FFMEPG, JPEG12, GPSTK, AWS_SDK, HDF5, OpenSceneGraph, PROJ4

- Build of OSSIM

- Build of OSSIM JNI

- Publishing the artifacts to jenkins and publishing the JNI to our Nexus Maven Repository.

## (Step 1) Create the Build Image

For now we only create a centos-7 build image.  The build image has all the tools necessary to build the dependencies and the OSSIM distribution.  It includes a c++ compiler, a make system, and other RPM packages. The centos-7 example [jenkins file](.centos-7/docker/Jenkinsfile) is used to show the steps in the build process.  It will do a docker build with the following [Dockerfile](./centos-7/docker/Dockerfile).

There are two arguments passed to the docker build that allows one to set the GROOVY and GRADLE versions downloaded and installed into the docker image:

- GRADLE_VERSION which defaults to 4.10.2
- GROOVY_VERSION which defaults to 2.4.15

The artifact produced from the build:

- **ossim-build-centos-7.tgz** Holds a tgz docker image called ossim-build-centos-7:latest. can be loaded using the command: **docker load -i ossim-build-centos-7.tgz**

## (Step 2) Build the OSSIM Dependencies

The OSSIM Dependencies are built using the docker image produced in [Step 1](#(Step-1)-Create-the-Build-Image).  To see the call made to start the build process please see the [Jenkinsfile](./centos-7/deps/Jenkinsfile).  It does use a variable called ARTIFACT_TYPE and is defaulted to a centos-7 target.  The artifacts produced from the build are:

- **ossim-deps-centos-7-all.tgz** Includes everything that was installed: include, lib/lib64, share, bin directories
- **ossim-deps-centos-7-dev.tgz** Includes the dev installation only: include, lib/lib64
- **ossim-deps-centos-7-runtime.tgz** Includes runtime installation only: bin, and lib/lib64 and the share.

## (Step 2) Build OSSIM

Building OSSIM uses the artifacts produced from [Step 1](#(Step-1)-Create-the-Build-Image) and [Step 2](#(Step-2)-Build-the-OSSIM-Dependencies).  The artifacts are extracted into the build instance and then scripts are executed to build the ossim dependencies.  Jenkins is used to orchestrate the checkout of the OSSIM source code and to upload artifacts to nexus and to the jenkins build pipeline.

See the [Jenkinsfile](./centos-7/ossim/Jenkinsfile) for the build steps.  If you want to see the script that run the build see [build-ossim.sh](./build-ossim.sh).  The tricky part is to make sure the envirnment variables get passed.  We write out an env file and then this env file is passed to our [docker-run.sh](./docker-run.sh) script.

The artifacts produced from this build step are:

- **ossim-centos-7-all.tgz** Includes everything that was installed: include, lib/lib64, share, bin directories
- **ossim-centos-7-dev.tgz** Includes the dev installation only: include, lib/lib64
- **ossim-centos-7-runtime.tgz** Includes runtime installation only: bin, and lib/lib64 and the share.
- **ossim-sandbox-centos-7-runtime.tgz** This include all shared library dependencies for OSSIM, OSSIM Depenencies, and any system shared libraries detected using a recursive ldd approach.  This includes enough information that it should be able to run selfcontained on a minimal CentOS 7 instance.


