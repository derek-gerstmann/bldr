#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="torque"

pkg_default="2.5.12"
pkg_variants=("2.5.12")

pkg_info="The TORQUE Resource Manager provides control over batch jobs and distributed computing resources."

pkg_desc="TORQUE Resource Manager provides control over batch jobs and distributed computing resources. 

It is an advanced open-source product based on the original PBS project* and incorporates the best 
of both community and professional development. It incorporates significant advances in the areas 
of scalability, reliability, and functionality and is currently in use at tens of thousands of 
leading government, academic, and commercial sites throughout the world. 

TORQUE may be freely used, modified, and distributed under the constraints of the included license."

pkg_opts="configure skip-xcode-config"
pkg_reqs="tcl libxml2 zlib hwloc papi openssl"
pkg_uses="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                     \
    --category    "$pkg_ctry"        \
    --name        "$pkg_name"        \
    --version     "$pkg_default"     \
    --requires    "$pkg_reqs"        \
    --uses        "$pkg_uses"        \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg+="--with-rcp=scp "
pkg_cfg+="--with-hwloc-path=\"$BLDR_HWLOC_BASE_PATH\" "
pkg_cfg+="--with-tcl=\"$BLDR_TCL_LIB_PATH\" "
tm_cfg=$pkg_cfg

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
    bldr_log_status "$pkg_name $pkg_vers is not building on OSX right now.  Skipping ..."
    bldr_log_split
else
    for pkg_vers in ${pkg_variants[@]}
    do
        pkg_file="$pkg_name-$pkg_vers.tar.gz"
        pkg_urls="http://www.adaptivecomputing.com/resources/downloads/torque/$pkg_file"
        pkg_cfg="$tm_cfg --with-server-home=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/var/spool/pbs"

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
fi

####################################################################################################

