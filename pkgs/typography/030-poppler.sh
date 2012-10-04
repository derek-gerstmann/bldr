#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="poppler"

pkg_info="Poppler is a PDF rendering library based on the xpdf-3.0 code base."

pkg_desc="Poppler is a PDF rendering library based on the xpdf-3.0 code base."

pkg_vers_dft="0.20.2"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure force-bootstrap enable-static enable-shared"
pkg_cfg="--enable-zlib"

pkg_reqs=""
pkg_reqs="$pkg_reqs zlib"
pkg_reqs="$pkg_reqs libicu"
pkg_reqs="$pkg_reqs libxml2"
pkg_reqs="$pkg_reqs lcms2"
pkg_reqs="$pkg_reqs libpng"
pkg_reqs="$pkg_reqs libjpeg"
pkg_uses=$pkg_reqs

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://poppler.freedesktop.org/$pkg_file"

    bldr_register_pkg                 \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_vers_dft"\
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


