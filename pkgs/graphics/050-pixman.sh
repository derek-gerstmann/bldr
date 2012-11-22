#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="pixman"

pkg_default="0.28.0"
pkg_variants=("0.28.0")

pkg_info="Pixman is a low-level software library for pixel manipulation, providing features such as image compositing and trapezoid rasterization."

pkg_desc="Pixman is a low-level software library for pixel manipulation, providing 
features such as image compositing and trapezoid rasterization. Important users of 
pixman are the cairo graphics library and the X server.

Pixman is implemented as a library in the C programming language. It runs on many 
platforms, including Linux, BSD Derivatives, MacOS X, and Windows.

Pixman is free and open source software. It is available to be redistributed and/or 
modified under the terms of the MIT license. "

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
pkg_reqs+="pkg-config "
pkg_reqs+="libtool "
pkg_reqs+="zlib "
pkg_reqs+="libxml2 "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="gettext "
pkg_reqs+="glib "
pkg_reqs+="libpng "
pkg_reqs+="pango "
pkg_uses="$pkg_reqs"

pkg_cfg=""
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://cairographics.org/releases/$pkg_file"

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

    let pkg_idx++
done

####################################################################################################

