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
pkg_reqs=""
pkg_reqs="$pkg_reqs pkg-config/latest"
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs bzip2/latest"
pkg_reqs="$pkg_reqs pcre/latest"
pkg_reqs="$pkg_reqs libelf/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs libffi/latest"
pkg_reqs="$pkg_reqs gettext/latest"
pkg_reqs="$pkg_reqs python/2.7.3"

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
     pkg_reqs="$pkg_reqs libiconv/latest"
fi

pkg_uses="$pkg_reqs"

if [[ $BLDR_SYSTEM_IS_64BIT == true ]]
then
     pkg_cflags="-m64"
fi

pkg_cfg="--sysconfdir=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/etc"
pkg_cfg="$pkg_cfg --disable-maintainer-mode"
pkg_cfg="$pkg_cfg --disable-dependency-tracking"
pkg_cfg="$pkg_cfg --disable-dtrace" 
pkg_cfg="$pkg_cfg --with-pcre=system"

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_cfg="$pkg_cfg --with-libiconv=native"
else
     pkg_reqs="$pkg_reqs libiconv/latest"
     pkg_cfg="$pkg_cfg --with-libiconv=gnu"
     pkg_cfg="$pkg_cfg --with-libiconv-prefix=\"$BLDR_LIBICONV_BASE_PATH\""
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

