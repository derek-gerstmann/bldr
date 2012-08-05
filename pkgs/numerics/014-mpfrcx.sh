#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="mpfrcx"
pkg_vers="0.4.1"
pkg_info="MPFRCX is a library for the arithmetic of univariate polynomials over arbitrary precision real (Mpfr) or complex (Mpc) numbers, without control on the rounding."

pkg_desc="MPFRCX is a library for the arithmetic of univariate polynomials 
over arbitrary precision real (Mpfr) or complex (Mpc) numbers, without 
control on the rounding. For the time being, only the few functions needed 
to implement the floating point approach to complex multiplication are implemented. 

On the other hand, these comprise asymptotically fast multiplication routines 
such as Toom–Cook and the FFT.

The library is written by Andreas Enge and is distributed under the Gnu Lesser 
General Public License, either version 2.1 of the licence, or (at your option) 
any later version."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.multiprecision.org/mpc/download/$pkg_file"
pkg_opts="configure"
pkg_reqs="gmp/latest mpfr/latest mpc/latest"
pkg_uses="tar/latest tcl/latest m4/latest autoconf/latest automake/latest $pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/gmp/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/gmp/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/mpfr/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/mpfr/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/mpc/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/mpc/latest/lib"

pkg_cfg="--with-gmp=$BLDR_LOCAL_PATH/numerics/gmp/latest"
pkg_cfg="$pkg_cfg --with-mpfr=$BLDR_LOCAL_PATH/numerics/mpfr/latest"
pkg_cfg="$pkg_cfg --with-mpc=$BLDR_LOCAL_PATH/numerics/mpfr/latest"
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

