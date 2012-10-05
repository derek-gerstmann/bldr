#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="libjpeg"

pkg_default="8d"
pkg_variants=("8d")

pkg_info="JPEG is a standardized compression method for full-color and gray-scale images."

pkg_desc="JPEG is a standardized compression method for full-color and gray-scale images.
This package from the Independent JPEG Group contains C software to implement JPEG 
image encoding, decoding, and transcoding.  

The distributed programs provide conversion between JPEG 'JFIF' format and
image files in PBMPLUS PPM/PGM, GIF, BMP, and Targa file formats.  The
core compression and decompression library can easily be reused in other
programs, such as image viewers.  The package is highly portable C code;
we have tested it on many machines ranging from PCs to Crays."

pkg_opts="configure force-static"
pkg_reqs="zlib"
pkg_uses="zlib"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="jpegsrc.v$pkg_vers.tar.gz"
     pkg_urls="http://www.ijg.org/files/$pkg_file"

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
