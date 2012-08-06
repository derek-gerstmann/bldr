#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="mpfr"
pkg_vers="3.1.1"
pkg_info="GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers."

pkg_desc="The MPFR library is a C library for multiple-precision floating-point 
computations with correct rounding. MPFR has continuously been supported by the 
INRIA and the current main authors come from the Caramel and AriC project-teams 
at Loria (Nancy, France) and LIP (Lyon, France) respectively. 

MPFR is based on the GMP multiple-precision library.

The main goal of MPFR is to provide a library for multiple-precision floating-point 
computation which is both efficient and has a well-defined semantics. It copies the 
good ideas from the ANSI/IEEE-754 standard for double-precision floating-point 
arithmetic (53-bit significand)."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://www.mpfr.org/mpfr-current/$pkg_file"
pkg_opts="configure"
pkg_reqs="gmp/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib:-lz"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/gmp/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/gmp/latest/lib:-lgmp"

pkg_cfg="--with-gmp=$BLDR_LOCAL_PATH/numerics/gmp/latest"
pkg_patch=""

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
               --patch       "$pkg_patch"   \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

