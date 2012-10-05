#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="zookeeper"

pkg_default="3.3.6"
pkg_variants=("3.3.6")

pkg_info="Apache ZooKeeper is an effort to develop and maintain an open-source server which enables highly reliable distributed coordination."

pkg_desc="Apache ZooKeeper is an effort to develop and maintain an open-source server which enables highly reliable distributed coordination.

ZooKeeper is a centralized service for maintaining configuration information, naming, 
providing distributed synchronization, and providing group services. All of these kinds 
of services are used in some form or another by distributed applications. Each time they 
are implemented there is a lot of work that goes into fixing the bugs and race conditions 
that are inevitable. Because of the difficulty of implementing these kinds of services, 
applications initially usually skimp on them ,which make them brittle in the presence 
of change and difficult to manage. Even when done correctly, different implementations 
of these services lead to management complexity when the applications are deployed."

pkg_opts="configure skip-config skip-build migrate-build-tree"
pkg_reqs=""
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
    if [[ -d "/usr/java/default" ]]
    then
        pkg_cfg+="JAVA_HOME=\"/usr/java/default\""
    fi
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://mirror.overthewire.com.au/pub/apache/zookeeper/stable/$pkg_file"

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
