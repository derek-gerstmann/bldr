#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="libjpeg"
pkg_vers="8d"

pkg_info="JPEG is a standardized compression method for full-color and gray-scale images."

pkg_desc="JPEG is a standardized compression method for full-color and gray-scale images.
This package from the Independent JPEG Group contains C software to implement JPEG 
image encoding, decoding, and transcoding.  

The distributed programs provide conversion between JPEG 'JFIF' format and
image files in PBMPLUS PPM/PGM, GIF, BMP, and Targa file formats.  The
core compression and decompression library can easily be reused in other
programs, such as image viewers.  The package is highly portable C code;
we have tested it on many machines ranging from PCs to Crays."

pkg_file="jpegsrc.v8d.tar.gz"
pkg_urls="http://www.ijg.org/files/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest"
pkg_uses="$pkg_reqs"
pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "imaging"      \
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


