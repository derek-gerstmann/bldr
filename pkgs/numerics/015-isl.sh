#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="isl"

pkg_default="0.10"
pkg_variants=("0.10")

pkg_info="ISL is a library for manipulating sets and relations of integer points bounded by linear constraints."

pkg_desc="ISL is a library for manipulating sets and relations of integer points bounded 
by linear constraints. Supported operations on sets include intersection, union, 
set difference, emptiness check, convex hull, (integer) affine hull, integer 
projection, and computing the lexicographic minimum using parametric integer programming. 

It also includes an ILP solver based on generalized basis reduction. 

ISL is released under LGPLv2.1"

pkg_opts="configure enable-static enable-shared"
pkg_reqs="gmp pip libtool automake autoconf m4"
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
pkg_cfg+="--with-piplib=\"$BLDR_PIP_BASE_PATH\" "

pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="ftp://gcc.gnu.org/pub/gcc/infrastructure/$pkg_file"

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

