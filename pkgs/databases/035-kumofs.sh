#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="kumofs"

pkg_default="0.4.13"
pkg_variants=("0.4.13")

pkg_info="Kumofs is a simple and fast distributed key-value store."

pkg_desc="Kumofs is a simple and fast distributed key-value store."

pkg_opts="configure enable-static enable-shared"
pkg_uses="zlib "
pkg_uses+="ruby "
pkg_uses+="tokyo-cabinet "
pkg_uses+="tokyo-cabinet-ruby "
pkg_uses+="msgpack "
pkg_uses+="msgpack-ruby "
pkg_uese+="openssl "
pkg_reqs+="$pkg_uses"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="https://github.com/downloads/etolabo/kumofs/$pkg_file"
     
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

