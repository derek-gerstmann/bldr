#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="4.7.0.2"
pkg_ctry="compilers"
pkg_name="gupc"
pkg_info="The GCC UPC toolset provides a compilation and execution environment for programs written in the UPC (Unified Parallel C) language."

pkg_desc="The GCC UPC toolset provides a compilation and execution environment for programs 
written in the UPC (Unified Parallel C) language.

The GNU UPC compiler extends the capabilities of the GNU GCC compiler. The GNU UPC 
compiler is implemented as a C Language dialect translator, in a fashion similar to 
the implementation of the GNU Objective C compiler."

pkg_file="upc-$pkg_vers.src.tar.bz2"
pkg_urls="http://www.gccupc.org/downloads/upc/rls/upc-$pkg_vers/$pkg_file"
pkg_opts="configure skip-xcode-config"

pkg_reqs="$pkg_reqs gcc/latest"
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs gmp/latest"
pkg_reqs="$pkg_reqs ppl/latest"
pkg_reqs="$pkg_reqs mpfr/latest"
pkg_reqs="$pkg_reqs mpc/latest"
pkg_reqs="$pkg_reqs isl/latest"
pkg_reqs="$pkg_reqs osl/latest"
pkg_reqs="$pkg_reqs cloog/latest"
pkg_reqs="$pkg_reqs perl/latest"
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

pkg_cfg="--disable-bootstrap"
pkg_cfg="$pkg_cfg --enable-languages=upc"
pkg_cfg="$pkg_cfg --with-gmp=\"$BLDR_GMP_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-isl=\"$BLDR_ISL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-osl=\"$BLDR_OSL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-mpfr=\"$BLDR_MPFR_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-mpc=\"$BLDR_MPC_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-ppl=\"$BLDR_PPL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-cloog=\"$BLDR_CLOOG_BASE_PATH\""
pkg_cfg="$pkg_cfg --enable-cloog-backend=isl"
pkg_cfg="$pkg_cfg --disable-ppl-version-check"
pkg_cfg="$pkg_cfg --disable-cloog-version-check"
pkg_cfg="$pkg_cfg --with-system-zlib"
pkg_cfg="$pkg_cfg --disable-nls"
pkg_cfg="$pkg_cfg --disable-multilib"
pkg_cfg="$pkg_cfg --enable-lto"

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    pkg_cfg="$pkg_cfg --without-gnu-ld"
fi

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################
if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    bldr_log_warning "'$pkg_name/$pkg_vers' is not building on OSX.  Skipping ..."
else

    bldr_build_pkg                   \
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
        --patch       "$pkg_patch"   \
        --cflags      "$pkg_cflags"  \
        --ldflags     "$pkg_ldflags" \
        --config      "$pkg_cfg"
fi
