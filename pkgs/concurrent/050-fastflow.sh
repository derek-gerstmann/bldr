#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="concurrent"
pkg_name="fastflow"

pkg_info="FastFlow is a multi-core parallel programming framework."

pkg_desc="FastFlow is a multi-core parallel programming framework 
implemented as a C++ template library that offers a set of mechanisms 
to support low-latency and high-bandwidth data flows in a network of 
threads running on cache-coherent multi-core architectures."

pkg_vers_dft="2.0.0"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="cmake force-serial-build migrate-build-bin migrate-build-headers migrate-build-tree"
pkg_reqs="zlib bzip2 boost gsl"
pkg_uses="cmake"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                   \
  --category    "$pkg_ctry"        \
  --name        "$pkg_name"        \
  --version     "$pkg_vers_dft"    \
  --requires    "$pkg_reqs"        \
  --uses        "$pkg_uses"        \
  --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg="$pkg_cfg:-DBUILD_TESTS=1"
pkg_cfg="$pkg_cfg:-DBUILD_EXAMPLES=0"
pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=\"$BLDR_ZLIB_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=\"$BLDR_ZLIB_LIB_PATH/libz.a\""
pkg_cfg="$pkg_cfg:-DBoost_NO_SYSTEM_PATHS=ON"
pkg_cfg="$pkg_cfg:-DBoost_NO_BOOST_CMAKE=ON"
pkg_cfg="$pkg_cfg:-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_INCLUDEDIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_ROOT=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBOOST_INCLUDEDIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg:-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DGSL_CONFIG_EXECUTABLE=\"$BLDR_GSL_BIN_PATH/gsl-config\""

pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    pkg_cflags="$pkg_cflags:-I/opt/X11/include"
    pkg_ldflags="$pkg_ldflags:-L/opt/X11/lib"
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://mc-fastflow.svn.sourceforge.net/viewvc/mc-fastflow/?view=tar"

    bldr_register_pkg                 \
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
