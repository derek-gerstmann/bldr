#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="lcms2"
pkg_vers="2.3"

pkg_info="The Little Color Management System implements fast transforms between ICC profiles."

pkg_desc="The Little Color Management System implements fast transforms between ICC profiles.

Little CMS adds basic ICC profile support. Then you can use the profiles to 
prepare a bitmap for display, keeping the original image colors. Little CMS 
is also useful for quickly converting between color spaces. Little CMS can 
also generate accurate separations based on the target printer, or inversely 
it can recover RGB data from a stored separation. Also, Little CMS can 'Proof'
an image, showing the final colors as they would be rendered on a specific device.

Less common usage would be to convert from RGB to CMYK accurately, to convert 
separations done for one printer to another printer, to use CIEL*a*b as working 
space, to read Lab TIFF, to characterize Colorimetric PNG, etc. etc."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://sourceforge.net/projects/lcms/files/lcms/2.3/$pkg_file?download"
pkg_opts="configure"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs="zlib/latest"
pkg_cflags="-I$BLDR_LOCAL_PATH/system/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/system/zlib/latest/lib"
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


