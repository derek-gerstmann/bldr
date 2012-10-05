#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="lcms2"

pkg_default="2.3"
pkg_variants=("$pkg_default")

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

pkg_opts="configure enable-static enable-shared"
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
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://sourceforge.net/projects/lcms/files/lcms/$pkg_vers/$pkg_file?download"

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
