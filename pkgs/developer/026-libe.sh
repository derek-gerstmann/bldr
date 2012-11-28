#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="libe"

pkg_default="0.2.7"
pkg_variants=("0.2.7")

pkg_info="C++ interfaces for efficient data structures (used internally for HyperDex)"
pkg_desc="$pkg_info"

pkg_opts="configure"
pkg_reqs="libtool zlib"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_status "$pkg_name $pkg_vers is not building on OSX right now.  Skipping ..."
     bldr_log_split
else
     for pkg_vers in ${pkg_variants[@]}
     do
          pkg_file="$pkg_name-$pkg_vers.tar.gz"
          pkg_urls="http://hyperdex.org/src/$pkg_file"

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
fi

####################################################################################################

