#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="concurrent"
pkg_name="lunchbox"
pkg_vers="1.4"
pkg_info="A concurrency toolbox, since the free lunch is over."

pkg_desc="A concurrency toolbox, since the free lunch is over.  Used internally by Eyescale's Collage networking framework."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="git://github.com/Eyescale/Lunchbox.git"
pkg_opts="cmake"
pkg_reqs="tar/latest boost/latest"
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

pkg_cfg="$pkg_cfg:-DBoost_NO_SYSTEM_PATHS=ON"
pkg_cfg="$pkg_cfg:-DBoost_NO_BOOST_CMAKE=ON"
pkg_cfg="$pkg_cfg:-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\""

pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

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


