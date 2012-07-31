#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="libpng"
pkg_vers="1.5.10"

pkg_info="PNG is an open, extensible image format with lossless compression."

pkg_desc="PNG is an open, extensible image format with lossless compression.
Libpng is the official PNG reference library. It supports almost all PNG 
features, is extensible, and has been extensively tested for over 16 years."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://prdownloads.sourceforge.net/libpng/$pkg_file?download"
pkg_opts="configure"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs="zlib/latest"
pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"
pkg_cfg="--with-zlib-prefix=$BLDR_LOCAL_PATH/internal/zlib/latest --with-pkgconfigdir=$PKG_CONFIG_PATH"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "imaging"      \
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


