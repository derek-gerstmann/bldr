#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="lightcloud-tyrant"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="Tokyo Tyrant manager for LightCloud, a distributed and persistent key-value database."

pkg_desc="Tokyo Tyrant manager for LightCloud, a distributed and persistent key-value database."

pkg_opts="configure "
pkg_opts+="skip-config "
pkg_opts+="skip-compile "
pkg_opts+="skip-install "
pkg_opts+="migrate-build-tree "

pkg_cfg=""

pkg_reqs=""
pkg_reqs+="python "
pkg_reqs+="lightcloud "
pkg_reqs+="tokyo-tyrant "

pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
      pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
      pkg_urls="git://github.com/Plurk/Tyrant-manager.git"
      
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

