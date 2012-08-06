#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="freetype"
pkg_vers="2.4.10"

pkg_info="FreeType is a free, high-quality, and portable font engine."

pkg_desc="FreeType 2 is a software font engine that is designed to be small, efficient, 
highly customizable, and portable while capable of producing high-quality output 
(glyph images). It can be used in graphics libraries, display servers, font conversion 
tools, text image generation tools, and many other products as well.

Note that FreeType 2 is a font service and doesn't provide APIs to perform higher-level 
features like text layout or graphics processing (e.g., colored text rendering, ‘hollowing’, 
etc.). However, it greatly simplifies these tasks by providing a simple, easy to use, 
and uniform interface to access the content of font files."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://download.savannah.gnu.org/releases/freetype/$pkg_file;http://downloads.sourceforge.net/project/$pkg_name/freetype2/$pkg_vers/$pkg_file?use_mirror=aarnet"
pkg_opts="configure force-serial-build"
pkg_reqs="zlib/latest libicu/latest libxml2/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"
pkg_cfg=""
pkg_patch=""

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


