#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="zeromq-java"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="Java Bindings for ZeroMQ -- a set of components for building scalable and high performance distributed applications"

pkg_desc="Java Bindings for ZeroMQ -- a set of components for building scalable and high 
performance distributed applications"

pkg_opts="configure enable-static enable-shared force-bootstrap force-serial-build"
pkg_reqs="pkg-config gettext zeromq/2.1.7"
pkg_uses="autoconf automake m4 libtool"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--with-zeromq=$BLDR_ZEROMQ_BASE_PATH" 

####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    export JAVA_HEADERS="/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers"
    export JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers"
else
    if [[ -d "/usr/java/default" ]]
    then
        pkg_cfg+="JAVA_HOME=\"/usr/java/default\""
    fi
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

for zmq_vers in ${pkg_variants[@]}
do
     pkg_vers=$zmq_vers
     pkg_file="$pkg_name-$zmq_vers.tar.gz"
     pkg_urls="git://github.com/zeromq/jzmq.git"

     bldr_register_pkg                 \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_default" \
          --info        "$pkg_info"    \
          --description "$pkg_desc"    \
          --file        "$pkg_file"    \
          --url         "$pkg_urls"    \
          --uses        "$pkg_uses"    \
          --requires    "$pkg_reqs"    \
          --options     "$pkg_opts"    \
          --cflags      "$pkg_cflags"  \
          --ldflags     "$pkg_ldflags" \
          --config      "$pkg_cfg"     \
          --config-path "$pkg_cfg_path"
done

####################################################################################################

