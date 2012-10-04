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

pkg_vers_dft="1.0"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_reqs="gmp mpfr"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################
  
bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_vers_dft"\
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--with-gmp=\"$BLDR_GMP_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-mpfr=\"$BLDR_MPFR_BASE_PATH\""

pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do

    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.multiprecision.org/mpc/download/$pkg_file"

    bldr_register_pkg                  \
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

