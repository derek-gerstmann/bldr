#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="tokyo-cabinet-ruby"

pkg_default="1.31"
pkg_variants=("1.31")

pkg_info="The Tokyo Cabinet ruby API provides hooks to a library of routines for managing a database."

pkg_desc="The Tokyo Cabinet ruby API provides hooks to a library of routines for managing a database."

pkg_opts="ruby skip-install migrate-build-bin"

pkg_reqs="ruby tokyo-cabinet"
pkg_uses="tar $pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="tokyocabinet-ruby-$pkg_vers.tar.gz"
     pkg_urls="http://fallabs.com/tokyocabinet/rubypkg/$pkg_file"
     
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

