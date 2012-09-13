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
pkg_vers="0.4.13"

pkg_info="Kumofs is a simple and fast distributed key-value store."

pkg_desc="Kumofs is a simple and fast distributed key-value store."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="https://github.com/downloads/etolabo/kumofs/$pkg_file"
pkg_opts="configure"
pkg_uses="zlib/latest"
pkg_uses="$pkg_uses ruby/latest"
pkg_uses="$pkg_uses tokyo-cabinet/latest"
pkg_uses="$pkg_uses tokyo-cabinet-ruby/latest"
pkg_uses="$pkg_uses msgpack/latest"
pkg_uses="$pkg_uses msgpack-ruby/latest"
pkg_uese="$pkg_uses openssl/latest"
pkg_reqs="$pkg_uses"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

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
