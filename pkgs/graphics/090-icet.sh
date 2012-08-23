#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="icet"
pkg_vers="2.1.1"

pkg_info="The Image Composition Engine for Tiles (IceT) is a high-performance sort-last parallel rendering library."

pkg_desc="The Image Composition Engine for Tiles (IceT) is a high-performance sort-last parallel rendering library. 

In addition to providing accelerated rendering for a standard display, IceT provides the unique ability to 
generate images for tiled displays. The overall resolution of the display may be several times larger than 
any viewport that may be rendered by a single machine.

IceT is currently available for use in large scale, high performance visualization and graphics applications. 
It is used in multiple production products like ParaView and VisIt. You can track the development of 
IceT with the Ohloh project."

pkg_file="IceT-2-1-1.tar.gz"
pkg_urls="http://icet.sandia.gov/downloads/$pkg_file"
pkg_opts="cmake"
pkg_reqs="openmpi/latest"
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
