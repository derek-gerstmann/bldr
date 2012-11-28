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

pkg_default="0.20.2"
pkg_variants=("0.20.2")

pkg_info="Poppler is a PDF rendering library based on the xpdf-3.0 code base."

pkg_desc="Poppler is a PDF rendering library based on the xpdf-3.0 code base."

pkg_opts="configure "
pkg_opts+="force-bootstrap "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_cfg="--enable-zlib"

pkg_reqs="libtool "
pkg_reqs+="zlib "
pkg_reqs+="libicu "
pkg_reqs+="libxml2 "
pkg_reqs+="lcms2 "
pkg_reqs+="libpng "
pkg_reqs+="libjpeg "
pkg_reqs+="fontconfig "
pkg_uses=$pkg_reqs

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://poppler.freedesktop.org/$pkg_file"

    bldr_register_pkg                 \
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


