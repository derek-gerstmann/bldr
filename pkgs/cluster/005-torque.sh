#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="torque"
pkg_vers="2.5.7"

pkg_info="The TORQUE Resource Manager provides control over batch jobs and distributed computing resources."

pkg_desc="TORQUE Resource Manager provides control over batch jobs and distributed computing resources. 

It is an advanced open-source product based on the original PBS project* and incorporates the best 
of both community and professional development. It incorporates significant advances in the areas 
of scalability, reliability, and functionality and is currently in use at tens of thousands of 
leading government, academic, and commercial sites throughout the world. 

TORQUE may be freely used, modified, and distributed under the constraints of the included license."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.adaptivecomputing.com/resources/downloads/torque/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest papi/latest"
pkg_uses="m4/latest autoconf/latest automake/latest $pkg_reqs"
pkg_cflags="-I$BLDR_LOCAL_PATH/system/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/system/zlib/latest/lib"
pkg_cfg=""

if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
then
     return
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "cluster"      \
               --name        "$pkg_name"    \
               --version     "$pkg_vers"    \
               --info        "$pkg_info"    \
               --description "$pkg_desc"    \
               --file        "$pkg_file"    \
               --url         "$pkg_urls"    \
               --uses        "$pkg_uses"    \
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"


