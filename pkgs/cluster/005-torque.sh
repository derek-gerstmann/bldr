#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="cluster"
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
pkg_reqs="zlib/latest papi/latest hwloc/latest"
pkg_uses="$pkg_reqs"

pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

dep_list="internal/zlib system/hwloc system/papi"
for dep_pkg in $dep_list
do
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
then
     bldr_log_warning "$pkg_name is not supported on OSX.  Skipping ..."
     bldr_log_split
else
     bldr_build_pkg --category    "$pkg_ctry"    \
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
fi

