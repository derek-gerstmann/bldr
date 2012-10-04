#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="network"
pkg_name="collage"

pkg_info="Cross-platform C++ library for building heterogenous, distributed applications "

pkg_desc="Cross-platform C++ library for building heterogenous, distributed applications."

pkg_vers_dft="trunk"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="cmake force-inplace-build"
pkg_reqs="tar boost lunchbox"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_vers_dft"\
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

export BOOST_ROOT=$BLDR_BOOST_BASE_PATH
export BOOST_INCLUDEDIR=$BLDR_BOOST_INCLUDE_PATH

pkg_cfg="$pkg_cfg:-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBOOST_INCLUDEDIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_NO_SYSTEM_PATHS=ON"
pkg_cfg="$pkg_cfg:-DBoost_NO_BOOST_CMAKE=ON"
pkg_cfg="$pkg_cfg:-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\""

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
      pkg_file="$pkg_name-$pkg_vers.tar.bz2"
      pkg_urls="git://github.com/Eyescale/Collage.git"

      bldr_register_pkg                \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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
done

####################################################################################################

