#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="cairo-cogl"
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

pkg_file="cairo-$pkg_vers.tar.xz"
pkg_urls="http://cairographics.org/releases/$pkg_file"
pkg_opts="configure force-bootstrap"
pkg_uses=""
pkg_reqs=""
pkg_cfg=""

pkg_reqs=""
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libiconv/latest"
pkg_reqs="$pkg_reqs gtk-doc/latest"
pkg_reqs="$pkg_reqs libtool/latest"
pkg_reqs="$pkg_reqs gettext/latest"
pkg_reqs="$pkg_reqs glib/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_reqs="$pkg_reqs freetype/latest"
pkg_reqs="$pkg_reqs fontconfig/latest"
pkg_reqs="$pkg_reqs pango/latest"
pkg_reqs="$pkg_reqs pixman/latest"
pkg_reqs="$pkg_reqs poppler/latest"
pkg_reqs="$pkg_reqs cogl/latest"

pkg_cfg="--disable-introspection"
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cfg="$pkg_cfg --disable-xlib --enable-quartz --enable-quartz-image --enable-cogl"
else
     pkg_cfg="$pkg_cfg --enable-gl --enable-cogl"     
fi

pkg_uses="$pkg_reqs"

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     bldr_log_warning "'$pkg_name/$pkg_vers' not supported on OSX!  Skipping ..."
else
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
fi
