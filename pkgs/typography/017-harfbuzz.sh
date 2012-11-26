#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="harfbuzz"

pkg_default="0.9.7"
pkg_variants=("0.9.7")

pkg_info="HarfBuzz is an OpenType text shaping engine."

pkg_desc="HarfBuzz is an OpenType text shaping engine."

pkg_opts="configure force-bootstrap "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_uses="libtool "
pkg_uses="automake "
pkg_uses="autoconf "
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

    for pkg_vers in ${pkg_variants[@]}
    do
        pkg_file="$pkg_name-$pkg_vers.tar.gz"
        pkg_urls="http://cgit.freedesktop.org/harfbuzz/snapshot/$pkg_file"

        bldr_register_pkg                  \
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

