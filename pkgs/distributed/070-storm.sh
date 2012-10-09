#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="storm"

pkg_default="0.8.1"
pkg_variants=("0.8.1")

pkg_info="Storm is a distributed realtime computation system."

pkg_desc="Storm is a distributed realtime computation system.

Similar to how Hadoop provides a set of general primitives for doing batch processing, 
Storm provides a set of general primitives for doing realtime computation. Storm is 
simple, can be used with any programming language, is used by many companies, and is 
a lot of fun to use!"

pkg_opts="configure skip-config skip-build migrate-build-tree"
pkg_reqs="zeromq/2.1.7 zeromq-java ruby thrift"
pkg_uses="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
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
            pkg_cfg+="JAVA_HOME=\"/usr/java/default\""
        fi
    fi
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.zip"
    pkg_urls="https://github.com/downloads/nathanmarz/storm/$pkg_file"

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
