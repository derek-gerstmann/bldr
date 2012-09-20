#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="0.8.1"
pkg_ctry="distributed"
pkg_name="storm"

pkg_info="Storm is a distributed realtime computation system."

pkg_desc="Storm is a distributed realtime computation system.

Similar to how Hadoop provides a set of general primitives for doing batch processing, 
Storm provides a set of general primitives for doing realtime computation. Storm is 
simple, can be used with any programming language, is used by many companies, and is 
a lot of fun to use!"

pkg_opts="configure skip-config skip-build migrate-build-tree"
pkg_reqs="zeromq/2.1.7 zeromq-java/2.1.0 ruby/latest thrift/latest"
pkg_uses="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    export JAVA_HEADERS="/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers"
    export JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers"
else
    if [[ ! -d $JAVA_HOME ]]
    then
        if [[ -d "/usr/java/default" ]]
        then
            pkg_cfg="$pkg_cfg JAVA_HOME=\"/usr/java/default\""
        fi
    fi
fi

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

pkg_file="$pkg_name-$pkg_vers.zip"
pkg_urls="https://github.com/downloads/nathanmarz/storm/$pkg_file"
bldr_build_pkg                   \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_vers"    \
    --info        "$pkg_info"    \
    --description "$pkg_desc"    \
    --file        "$pkg_file"    \
    --url         "$pkg_urls"    \
    --uses        "$pkg_uses"    \
    --requires    "$pkg_reqs"    \
    --options     "$pkg_opts"    \
    --patch       "$pkg_patch"   \
    --cflags      "$pkg_cflags"  \
    --ldflags     "$pkg_ldflags" \
    --config      "$pkg_cfg"

