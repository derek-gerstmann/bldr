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

pkg_default="0.4.1"
pkg_variants=("0.4.1")

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

pkg_opts="configure enable-static enable-shared"
pkg_reqs="gmp mpfr mpc"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg+="--with-gmp=\"$BLDR_GMP_BASE_PATH\" "
pkg_cfg+="--with-mpfr=\"$BLDR_MPFR_BASE_PATH\" "
pkg_cfg+="--with-mpc=\"$BLDR_MPC_BASE_PATH\" "

pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.multiprecision.org/mpc/download/$pkg_file"

    bldr_register_pkg                  \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_default" \
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

