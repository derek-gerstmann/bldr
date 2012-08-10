#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="mpc"
pkg_vers="1.0"
pkg_info="Gnu Mpc is a C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result."

pkg_desc="Gnu Mpc is a C library for the arithmetic of complex numbers with 
arbitrarily high precision and correct rounding of the result. It extends the 
principles of the IEEE-754 standard for fixed precision real floating point 
numbers to complex numbers, providing well-defined semantics for every operation. 

At the same time, speed of operation at high precision is a major design goal.

The library is built upon and follows the same principles as Gnu Mpfr. It is written 
by Andreas Enge, Mickaël Gastineau, Philippe Théveny and Paul Zimmermann and is 
distributed under the Gnu Lesser General Public License, either version 3 of the 
licence, or (at your option) any later version. The Gnu Mpc library has been registered 
in France by the Agence pour la Protection des Programmes on 2003-02-05 under the 
number IDDN FR 001 060029 000 R P 2003 000 10000."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.multiprecision.org/mpc/download/$pkg_file"
pkg_opts="configure"
pkg_reqs="gmp/latest mpfr/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/compression/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/compression/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/gmp/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/gmp/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/mpfr/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/mpfr/latest/lib"

pkg_cfg="--with-gmp=$BLDR_LOCAL_PATH/numerics/gmp/latest"
pkg_cfg="$pkg_cfg --with-mpfr=$BLDR_LOCAL_PATH/numerics/mpfr/latest"
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

