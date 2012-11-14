#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="mongo-c"

pkg_default="0.6"
pkg_variants=("0.6")

pkg_info="C99-API driver for MongoDB."

pkg_desc="C99-API driver for MongoDB."

pkg_opts="configure "

pkg_uses="mongo-db"
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_opts="configure "
     pkg_opts+="-MINSTALL_INCLUDE_PATH=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include "
     pkg_opts+="-MINSTALL_LIBRARY_PATH=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib "
     pkg_urls="https://github.com/mongodb/mongo-c-driver/archive/v$pkg_vers.tar.gz"

     bldr_register_pkg                \
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


