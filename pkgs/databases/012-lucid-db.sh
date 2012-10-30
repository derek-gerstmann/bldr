#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="lucid-db"

pkg_default="0.9.4"
pkg_variants=("0.9.4")

pkg_info="LucidDB stands alone as the only open source database purpose-built for Business Intelligence."

pkg_desc="LucidDB stands alone as the only open source database purpose-built for Business Intelligence."

pkg_opts="configure skip-config skip-build migrate-build-tree"
pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
         pkg_file="luciddb-bin-linux64-$pkg_vers.tar.bz2"
     fi
     if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
         pkg_file="luciddb-bin-macos32-$pkg_vers.tar.bz2"
     fi

     if [[ "$pkg_file" != "" ]]; then
         pkg_urls="http://dist.dynamobi.com/$pkg_vers/$pkg_file"

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
     fi
done

####################################################################################################

