#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="libexif"
pkg_vers="0.6.21"

pkg_info="libexif is an ANSI-C library that reads and writes EXIF metainformation from and to image files."

pkg_desc="libexif is an ANSI-C library that reads and writes EXIF metainformation from and to image files."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://downloads.sourceforge.net/project/libexif/$pkg_name/$pkg_vers/$pkg_file?use_miror=aarnet"
pkg_opts="configure"
pkg_reqs="zlib/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

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


