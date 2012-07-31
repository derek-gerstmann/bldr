#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="eq"
pkg_vers="1.4.9"

pkg_info="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications."

pkg_desc="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications. 

It enables applications to benefit from multiple graphics cards, processors and computers to scale 
the rendering performance, visual quality and display size. An Equalizer application runs unmodified 
on any visualization system, from a simple workstation to large scale graphics clusters, 
multi-GPU workstations and Virtual Reality installations"

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="https://github.com/Eyescale/Equalizer.git"
pkg_opts="cmake keep"
pkg_reqs="zlib/latest"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=$BLDR_LOCAL_PATH/internal/zlib/latest/lib/libz.a"

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

####################################################################################################
