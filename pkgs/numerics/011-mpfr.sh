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

pkg_default="3.1.1"
pkg_variants=("3.1.1")

pkg_info="MPFR is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers."

pkg_desc="The MPFR library is a C library for multiple-precision floating-point 
computations with correct rounding. MPFR has continuously been supported by the 
INRIA and the current main authors come from the Caramel and AriC project-teams 
at Loria (Nancy, France) and LIP (Lyon, France) respectively. 

MPFR is based on the GMP multiple-precision library.

The main goal of MPFR is to provide a library for multiple-precision floating-point 
computation which is both efficient and has a well-defined semantics. It copies the 
good ideas from the ANSI/IEEE-754 standard for double-precision floating-point 
arithmetic (53-bit significand)."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="gmp"
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

pkg_cfg="--with-gmp=\"$BLDR_GMP_BASE_PATH\""
pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="http://www.mpfr.org/mpfr-current/$pkg_file"

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

