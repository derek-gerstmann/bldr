#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers_list=("2.5.12" "4.1.0")
pkg_ctry="cluster"
pkg_name="torque"

pkg_info="The TORQUE Resource Manager provides control over batch jobs and distributed computing resources."

pkg_desc="TORQUE Resource Manager provides control over batch jobs and distributed computing resources. 

It is an advanced open-source product based on the original PBS project* and incorporates the best 
of both community and professional development. It incorporates significant advances in the areas 
of scalability, reliability, and functionality and is currently in use at tens of thousands of 
leading government, academic, and commercial sites throughout the world. 

TORQUE may be freely used, modified, and distributed under the constraints of the included license."

pkg_opts="configure disable-xcode-cflags disable-xcode-ldflags"
pkg_reqs=""
pkg_uses=""

pkg_cfg=""
pkg_cfg="$pkg_cfg --with-rcp=scp"
pkg_cfg="$pkg_cfg --with-hwloc-path=$BLDR_LOCAL_PATH/system/hwloc/latest"
pkg_cfg="$pkg_cfg --with-tcl=$BLDR_LOCAL_PATH/languages/tcl/latest/lib"
tm_cfg=$pkg_cfg

pkg_cflags=""
pkg_ldflags=""

dep_list="languages/tcl developer/libxml2 compression/zlib system/hwloc system/papi network/openssl"
for dep_pkg in $dep_list
do
     pkg_req_name=$(echo "$dep_pkg" | sed 's/.*\///g' )
     pkg_reqs="$pkg_reqs $pkg_req_name/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_status "$pkg_name $pkg_vers is not building on OSX right now.  Skipping ..."
     bldr_log_split
else
     for pkg_vers in ${pkg_vers_list}
     do
          pkg_file="$pkg_name-$pkg_vers.tar.gz"
          pkg_urls="http://www.adaptivecomputing.com/resources/downloads/torque/$pkg_file"
          pkg_cfg="$tm_cfg --with-server-home=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/var/spool/pbs"
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
                         --patch       "$pkg_patch"   \
                         --cflags      "$pkg_cflags"  \
                         --ldflags     "$pkg_ldflags" \
                         --config      "$pkg_cfg"
     done
fi
