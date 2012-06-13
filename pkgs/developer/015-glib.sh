#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="glib"
pkg_vers="2.32.3"
pkg_info="GLib provides the core application building blocks for libraries and applications written in C."

pkg_desc="GLib provides the core application building blocks for libraries and applications written in C. 
It provides the core object system used in GNOME, the main loop implementation, and a large set of 
utility functions for strings and common data structures."

pkg_file="$pkg_name-$pkg_vers.tar.xz"
pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/glib/2.32/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest libiconv/latest libicu/latest libxml2/latest libffi/latest gettext/latest"
pkg_uses="tcl/latest m4/latest autoconf/latest automake/latest $pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_DIR/system/zlib/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_DIR/system/libicu/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_DIR/system/libiconv/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_DIR/system/libffi/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_DIR/system/gettext/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_DIR/system/gettext/latest/share/gettext"

pkg_ldflags="-L$BLDR_LOCAL_DIR/system/zlib/latest/lib:-lz"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_DIR/system/libffi/latest/lib:-lffi"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_DIR/system/libicu/latest/lib"
pkg_ldflags="$pkg_ldflags:-licudata:-licui18n:-licuio:-licule:-liculx:-licutest:-licutu:-licuuc"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_DIR/system/libiconv/latest/lib:-liconv"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_DIR/system/gettext/latest/lib:-lasprintf:-lgettextpo"

pkg_cfg="--with-libiconv=gnu" 

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "developer"    \
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


