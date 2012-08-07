#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="concurrency"
pkg_name="ff"
pkg_vers="2.0.0"

pkg_info="FastFlow is a multi-core parallel programming framework."

pkg_desc="FastFlow is a multi-core parallel programming framework 
implemented as a C++ template library that offers a set of mechanisms 
to support low-latency and high-bandwidth data flows in a network of 
threads running on cache-coherent multi-core architectures."

pkg_file="$pkg_name-cpp-$pkg_vers.tar.gz"
pkg_urls="http://mc-fastflow.svn.sourceforge.net/viewvc/mc-fastflow/?view=tar"
pkg_opts="cmake force-serial-build"
pkg_reqs="zlib/latest bzip2/latest boost/latest gsl/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg="$pkg_cfg:-DBUILD_TESTS=1"
pkg_cfg="$pkg_cfg:-DBUILD_EXAMPLES=0"
pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=$BLDR_LOCAL_PATH/internal/zlib/latest/lib/libz.a"
pkg_cfg="$pkg_cfg:-DBOOST_INCLUDEDIR=$BLDR_LOCAL_PATH/developer/boost/latest/include"
pkg_cfg="$pkg_cfg:-DBOOST_ROOT=$BLDR_LOCAL_PATH/developer/boost/latest"
pkg_cfg="$pkg_cfg:-DBoost_DIR=$BLDR_LOCAL_PATH/developer/boost/latest"
pkg_cfg="$pkg_cfg:-DGSL_CONFIG_EXECUTABLE=$BLDR_LOCAL_PATH/science/gsl/latest/bin/gsl-config"

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
