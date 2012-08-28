#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="libpng"
pkg_vers="1.5.12"

pkg_info="PNG is an open, extensible image format with lossless compression."

pkg_desc="PNG is an open, extensible image format with lossless compression.
Libpng is the official PNG reference library. It supports almost all PNG 
features, is extensible, and has been extensively tested for over 16 years."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://prdownloads.sourceforge.net/libpng/$pkg_file?download"
pkg_opts="configure force-static"
pkg_reqs="zlib/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg="$pkg_cfg --with-zlib-prefix=\"$BLDR_ZLIB_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-pkgconfigdir=$PKG_CONFIG_PATH"
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags="$pkg_cflags -fPIC"
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


