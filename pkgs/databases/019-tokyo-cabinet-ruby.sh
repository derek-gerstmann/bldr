#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="1.31"
pkg_vers_list=("$pkg_vers")
pkg_ctry="databases"
pkg_name="tokyo-cabinet-ruby"
pkg_info="The Tokyo Cabinet ruby API provides hooks to a library of routines for managing a database."

pkg_desc="The Tokyo Cabinet ruby API provides hooks to a library of routines for managing a database."

pkg_file="tokyocabinet-ruby-$pkg_vers.tar.gz"
pkg_opts="ruby skip-install migrate-build-bin"
pkg_urls="http://fallabs.com/tokyocabinet/rubypkg/$pkg_file"
pkg_reqs="ruby/latest tokyo-cabinet/latest"
pkg_uses="tar/latest $pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_cflags="$pkg_cflags -fPIC"
fi

####################################################################################################
# build and install each pkg version as local module
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


