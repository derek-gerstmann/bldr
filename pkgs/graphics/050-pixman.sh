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
pkg_vers="0.26.2"

pkg_info="Pixman is a low-level software library for pixel manipulation, providing features such as image compositing and trapezoid rasterization."

pkg_desc="Pixman is a low-level software library for pixel manipulation, providing 
features such as image compositing and trapezoid rasterization. Important users of 
pixman are the cairo graphics library and the X server.

Pixman is implemented as a library in the C programming language. It runs on many 
platforms, including Linux, BSD Derivatives, MacOS X, and Windows.

Pixman is free and open source software. It is available to be redistributed and/or 
modified under the terms of the MIT license. "

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://cairographics.org/releases/$pkg_file"
pkg_opts="configure"
pkg_cfg=""
pkg_cfg_path=""

pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="compression/zlib text/libicu developer/libxml2"
dep_list="$dep_list text/gettext developer/glib"
dep_list="$dep_list imaging/libpng typography/pango"

if [[ $BLDR_SYSTEM_IS_OSX == false ]]; then
     dep_list="$dep_list text/libiconv"
fi

for dep_pkg in $dep_list
do
     pkg_req_name=$(echo "$dep_pkg" | sed 's/.*\///g' )
     pkg_reqs="$pkg_reqs $pkg_req_name/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cflags="$pkg_cflags:-I/usr/local/include:-I/usr/include"
     pkg_ldflags="$pkg_ldflags:-L/usr/local/lib:-L/usr/lib:-lintl"
fi

pkg_uses="$pkg_reqs"

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

