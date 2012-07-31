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
pkg_vers="0.20.2"

pkg_info="Poppler is a PDF rendering library based on the xpdf-3.0 code base."

pkg_desc="Poppler is a PDF rendering library based on the xpdf-3.0 code base."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://poppler.freedesktop.org/$pkg_file"
pkg_opts="configure"
pkg_cfg="--enable-zlib"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="internal/zlib internal/libicu internal/libxml2"
dep_list="$dep_list imaging/lcms2 imaging/libpng imaging/libjpeg"
if [[ $BLDR_SYSTEM_IS_OSX -eq 0 ]]; then
     dep_list="$dep_list internal/libiconv"
fi

for dep_pkg in $dep_list
do
     pkg_reqs="$pkg_reqs $dep_pkg/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest $pkg_reqs"

if [[ $BLDR_SYSTEM_IS_OSX -eq 1 ]]; then
     pkg_cflags="$pkg_cflags:-I/usr/local/include:-I/usr/include"
     pkg_ldflags="$pkg_ldflags:-L/usr/local/lib:-L/usr/lib:-lintl"
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
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

