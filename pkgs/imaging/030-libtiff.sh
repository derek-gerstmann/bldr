#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="libtiff"

pkg_default="4.0.2"
pkg_variants=("3.9.6" "4.0.2")

pkg_info="The Tag Image File Format (TIFF) is a widely used format for storing image data."

pkg_desc="The Tag Image File Format (TIFF) is a widely used format for storing image data.
This software provides support for the Tag Image File Format (TIFF), a widely used format 
for storing image data. The latest version of the TIFF specification is available on-line 
in several different formats.

Included in this software distribution is a library, libtiff, for reading and writing TIFF, 
a small collection of tools for doing simple manipulations of TIFF images, and documentation 
on the library and tools. Libtiff is a portable software, it was built and tested on various 
systems: UNIX flavors (Linux, BSD, Solaris, MacOS X), Windows, and OpenVMS. It should be 
possible to port libtiff and additional tools on other OSes.

The library, along with associated tool programs, should handle most of your needs for 
reading and writing TIFF images on 32- and 64-bit machines."

pkg_opts="configure force-static"
pkg_reqs="zlib libpng libjpeg"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--with-gnu-ld "
pkg_cfg+="--with-jpeg-lib-dir=\"$BLDR_LIBJPEG_LIB_PATH\" "
pkg_cfg+="--with-jpeg-include-dir=\"$BLDR_LIBJPEG_INCLUDE_PATH\" "
pkg_cfg+="--with-zlib-lib-dir=\"$BLDR_ZLIB_LIB_PATH\" "
pkg_cfg+="--with-zlib-include-dir=\"$BLDR_ZLIB_INCLUDE_PATH\" "

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="tiff-$pkg_vers.tar.gz"
    pkg_urls="http://download.osgeo.org/libtiff/$pkg_file"

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
