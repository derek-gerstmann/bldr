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
pkg_vers="1.4"

pkg_info="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications."

pkg_desc="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications. 

It enables applications to benefit from multiple graphics cards, processors and computers to scale 
the rendering performance, visual quality and display size. An Equalizer application runs unmodified 
on any visualization system, from a simple workstation to large scale graphics clusters, 
multi-GPU workstations and Virtual Reality installations"

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="https://github.com/Eyescale/Equalizer/tarball/1.4"
pkg_opts="cmake force-inplace-build"
pkg_reqs="zlib/latest vmmlib/latest lunchbox/latest glew/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_vers"    \
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

export BOOST_ROOT=$BLDR_BOOST_BASE_PATH
export BOOST_INCLUDEDIR=$BLDR_BOOST_INCLUDE_PATH

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBOOST_INCLUDEDIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_NO_SYSTEM_PATHS=ON"
pkg_cfg="$pkg_cfg:-DBoost_NO_BOOST_CMAKE=ON"
pkg_cfg="$pkg_cfg:-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\""

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
