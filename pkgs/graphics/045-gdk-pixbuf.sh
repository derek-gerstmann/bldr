#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="gdk-pixbuf"
pkg_vers="2.26.2"

pkg_info="GdkPixbuf is a library for image loading and manipulation."

pkg_desc="GdkPixbuf is a library for image loading and manipulation. The"

pkg_file="$pkg_name-$pkg_vers.tar.xz"
pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.26/$pkg_file"
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
pkg_reqs="$pkg_reqs gettext/latest"
pkg_reqs="$pkg_reqs glib/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_reqs="$pkg_reqs freetype/latest"
pkg_reqs="$pkg_reqs fontconfig/latest"
pkg_reqs="$pkg_reqs libjpeg/latest"
pkg_reqs="$pkg_reqs pixman/latest"
pkg_reqs="$pkg_reqs poppler/latest"
if [[ $BLDR_SYSTEM_IS_OSX == false ]]; then
     pkg_reqs="$pkg_reqs cogl/latest"
fi

pkg_cfg=""
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cfg="$pkg_cfg --disable-xlib --enable-quartz --enable-quartz-image"
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

