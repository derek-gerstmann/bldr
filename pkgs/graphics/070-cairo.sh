#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="cairo"
pkg_vers="1.12.2"

pkg_info="Cairo is a 2D graphics library with support for multiple output devices."

pkg_desc="Cairo is a 2D graphics library with support for multiple output devices. 
Currently supported output targets include the X Window System (via both Xlib and XCB), 
Quartz, Win32, image buffers, PostScript, PDF, and SVG file output. Experimental 
backends include OpenGL, BeOS, OS/2, and DirectFB.

Cairo is designed to produce consistent output on all output media while taking 
advantage of display hardware acceleration when available (eg. through the X Render Extension).

The cairo API provides operations similar to the drawing operators of PostScript 
and PDF. Operations in cairo including stroking and filling cubic Bézier splines, 
transforming and compositing translucent images, and antialiased text rendering. 

All drawing operations can be transformed by any affine transformation (scale, rotation, shear, etc.)

Cairo is implemented as a library written in the C programming language, but 
bindings are available for several different programming languages.

Cairo is free software and is available to be redistributed and/or modified 
under the terms of either the GNU Lesser General Public License (LGPL) version 
2.1 or the Mozilla Public License (MPL) version 1.1 at your option."

pkg_file="$pkg_name-$pkg_vers.tar.xz"
pkg_urls="http://cairographics.org/releases/$pkg_file"
pkg_opts="configure force-bootstrap"
pkg_uses=""
pkg_reqs=""
pkg_cfg=""

pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="internal/zlib internal/libicu internal/libxml2"
dep_list="$dep_list typography/freetype typography/fontconfig"
dep_list="$dep_list graphics/pixman imaging/libpng"
dep_list="$dep_list developer/gettext developer/glib"

if [[ $BLDR_SYSTEM_IS_OSX -eq 0 ]]; then
     dep_list="$dep_list internal/libiconv graphics/cogl"
fi

for dep_pkg in $dep_list
do
     pkg_req_name=$(echo "$dep_pkg" | sed 's/.*\///g' )
     pkg_reqs="$pkg_reqs $pkg_req_name/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

if [[ $BLDR_SYSTEM_IS_OSX -eq 1 ]]; then
     pkg_cfg="$pkg_cfg --disable-xlib --enable-quartz --enable-quartz-image"
     # pkg_ldflags="$pkg_ldflags:-framework:ApplicationServices"
     pkg_cflags="$pkg_cflags:-I/usr/local/include:-I/usr/include"
     pkg_ldflags="$pkg_ldflags:-L/usr/local/lib:-L/usr/lib:-lintl"
else
     pkg_cfg="$pkg_cfg --enable-drm --enable-directfb --enable-gl --enable-cogl"     
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

