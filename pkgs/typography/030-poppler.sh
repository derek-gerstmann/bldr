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
pkg_opts="configure force-bootstrap"
pkg_cfg="--enable-zlib"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list=""
dep_list="$dep_list compression/zlib"
dep_list="$dep_list text/libicu"
dep_list="$dep_list developer/libxml2"
dep_list="$dep_list imaging/lcms2"
dep_list="$dep_list imaging/libpng"
dep_list="$dep_list imaging/libjpeg"

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

