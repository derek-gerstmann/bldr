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
pkg_vers="trunk"

pkg_info="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications."

pkg_desc="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications. 

It enables applications to benefit from multiple graphics cards, processors and computers to scale 
the rendering performance, visual quality and display size. An Equalizer application runs unmodified 
on any visualization system, from a simple workstation to large scale graphics clusters, 
multi-GPU workstations and Virtual Reality installations"

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="git://github.com/Eyescale/Equalizer.git"
pkg_opts="cmake"
pkg_reqs="zlib/latest vmmlib/latest"
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                 \
  --category    "$pkg_ctry"    \
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
  --config      "$pkg_cfg"     \
  --config-path "$pkg_cfg_path"

####################################################################################################
