#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="libyaml"
pkg_vers="0.1.4"
pkg_info="LibYAML is a YAML 1.1 parser and emitter written in C."

pkg_desc="LibYAML is a YAML 1.1 parser and emitter written in C."

pkg_file="yaml-$pkg_vers.tar.gz"
pkg_urls="http://pyyaml.org/download/libyaml/$pkg_file"
pkg_opts="configure"
pkg_reqs="pkg-config/latest zlib/latest flex/latest bison/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags="$pkg_cflags -fPIC"
fi

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
               --patch       "$pkg_patch"   \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

