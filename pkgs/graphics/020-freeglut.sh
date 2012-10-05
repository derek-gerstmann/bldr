#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="freeglut"

pkg_default="2.8.0"
pkg_variants=("2.8.0")

pkg_info="FreeGlut is an Open Source alternative to the OpenGL Utility Toolkit (GLUT) library."

pkg_desc="FreeGlut is an Open Source alternative to the OpenGL Utility Toolkit (GLUT) library"

pkg_opts="configure enable-static enable-shared"
pkg_uses=""
pkg_reqs=""

pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name uses the native OSX version bundled with MacOSX.  Skipping..."
     bldr_log_split
else
     for pkg_vers in ${pkg_variants[@]}
     do
          pkg_file="$pkg_name-$pkg_vers.tar.gz"
          pkg_urls="http://prdownloads.sourceforge.net/$pkg_name/$pkg_file?download"

          bldr_register_pkg               \
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
fi

####################################################################################################

