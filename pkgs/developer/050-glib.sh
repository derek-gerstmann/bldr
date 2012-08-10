#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="glib"
pkg_vers="2.32.4"
pkg_info="GLib provides the core application building blocks for libraries and applications written in C."

pkg_desc="GLib provides the core application building blocks for libraries and applications written in C. 
It provides the core object system used in GNOME, the main loop implementation, and a large set of 
utility functions for strings and common data structures."

pkg_file="$pkg_name-$pkg_vers.tar.xz"
pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/glib/2.32/$pkg_file"
pkg_opts="configure"
pkg_reqs="pkg-config/latest zlib/latest libicu/latest libxml2/latest libffi/latest gettext/latest"
pkg_uses="$pkg_reqs"

if [[ $BLDR_SYSTEM_IS_64BIT == true ]]
then
  pkg_cflags="-m64"
fi

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/compression/zlib/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/text/libicu/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/developer/libffi/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/text/gettext/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/text/gettext/latest/share/gettext"

pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/compression/zlib/latest/lib:-lz"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/developer/libffi/latest/lib:-lffi"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/text/libicu/latest/lib"
pkg_ldflags="$pkg_ldflags:-licudata:-licui18n:-licuio:-licule:-liculx:-licutest:-licutu:-licuuc"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/text/gettext/latest/lib:-lasprintf:-lgettextpo"

pkg_cfg=""
pkg_cfg="$pkg_cfg --disable-maintainer-mode"
pkg_cfg="$pkg_cfg --disable-dependency-tracking"
pkg_cfg="$pkg_cfg --disable-dtrace" 

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_cfg="$pkg_cfg --with-libiconv-prefix=/usr"
     pkg_cflags="$pkg_cflags:-I/usr/local/include:-I/usr/include"
     pkg_ldflags="$pkg_ldflags:-L/usr/local/lib:-L/usr/lib:-lintl"
else
     pkg_reqs="$pkg_reqs libiconv/latest"
     pkg_cfg="$pkg_cfg --with-libiconv=gnu --with-libiconv-prefix=$BLDR_LOCAL_PATH/text/libiconv/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/text/libiconv/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/text/libiconv/latest/lib"
fi

pkg_patch=""

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
               --patch       "$pkg_patch"   \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

