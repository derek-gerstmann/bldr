#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="fontconfig"
pkg_vers="2.10.1"

pkg_info="FontConfig is a library for configuring and customizing font access. "

pkg_desc="Fontconfig is a library designed to provide system-wide font configuration, 
customization and application access. 

Fontconfig contains two essential modules, the configuration module which builds an 
internal configuration from XML files and the matching module which accepts font 
patterns and returns the nearest matching font."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.freedesktop.org/software/$pkg_name/release/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest libicu/latest libxml2/latest freetype/latest"
pkg_uses="$pkg_reqs"

pkg_cfg=""
pkg_patch=""

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/freetype/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/freetype/latest/lib"

if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
then
     pkg_cfg="$pkg_cfg --with-arch=x86_64"
     pkg_cfg="$pkg_cfg --with-sysroot=$BLDR_OSX_SYSROOT"
else
     pkg_reqs="$pkg_reqs libiconv/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/libiconv/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/libiconv/latest/lib"
fi

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


