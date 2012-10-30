#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="lemur-cobi"

pkg_default="2008-08-19"
pkg_variants=("2008-08-19")

pkg_info="A C++ library implementing column-oriented bitmap indexes."

pkg_desc="A C++ library implementing column-oriented bitmap indexes."

pkg_opts="configure enable-static enable-shared use-make-envflags"

pkg_reqs="tar zlib bzip2 lzo qdbm"
pkg_uses="$pkg_reqs"

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
pkg_ldflags="-L$BLDR_ZLIP_LIB_PATH -lz -L$BLDR_BZIP2_LIB_PATH -lbz2 -L$BLDR_QDBM_LIB_PATH -lqdbm"

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="lemurbitmapindex_$pkg_vers.zip"
     pkg_urls="http://lemurbitmapindex.googlecode.com/files/$pkg_file"

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

