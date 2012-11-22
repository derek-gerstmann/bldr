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

pkg_default="1.12.8"
pkg_variants=("1.12.8")

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

pkg_opts="configure "

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_opts+="force-bootstrap "
    pkg_opts+="skip-xcode-config "
    pkg_opts+="force-static "
else
    pkg_opts+="enable-static enable-shared "
fi

pkg_reqs="pkg-config "
pkg_reqs+="libtool "
pkg_reqs+="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="libxml2 "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="gtk-doc "
pkg_reqs+="libtool "
pkg_reqs+="gettext "
pkg_reqs+="glib "
pkg_reqs+="libpng/1.2.50 "
pkg_reqs+="freetype "
pkg_reqs+="fontconfig "
pkg_reqs+="pango "
pkg_reqs+="pixman "
pkg_reqs+="poppler "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--disable-introspection "
pkg_cfg+="--enable-script=no "
pkg_cfg+="--enable-test-surfaces=no "

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cfg+="--disable-xlib --disable-quartz-font --disable-quartz --without-x "
     pkg_cflags+="-DAC_APPLE_UNIVERSAL_BUILD=1 " 
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]] 
then
     pkg_cflags+="-fPIC "
fi

export png_CFLAGS="-I$BLDR_LIBPNG_INCLUDE_PATH"
export png_LDFLAGS="-L$BLDR_LIBPNG_LIB_PATH -lpng" 
export png_REQUIRES="libpng"

export pixman_CFLAGS="-I$BLDR_PIXMAN_INCLUDE_PATH -I$BLDR_PIXMAN_INCLUDE_PATH/pixman-1"
export pixman_LIBS="-L$BLDR_PIXMAN_LIB_PATH -lpixman-1" 
export pixman_REQUIRES="libpixman"

# pkg_ldflags+="\"$BLDR_ZLIB_LIB_PATH/libz.a\" "
# pkg_ldflags+="-L\"$BLDR_BZIP2_LIB_PATH\" -lbz2 "
# pkg_ldflags+="-L\"$BLDR_LIBPNG_LIB_PATH\" -lpng "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.xz"
     pkg_urls="http://cairographics.org/releases/$pkg_file"

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

    let pkg_idx++
done

####################################################################################################

