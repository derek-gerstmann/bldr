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
pkg_vers="0.10"
pkg_info="ISL is a library for manipulating sets and relations of integer points bounded by linear constraints."

pkg_desc="ISL is a library for manipulating sets and relations of integer points bounded 
by linear constraints. Supported operations on sets include intersection, union, 
set difference, emptiness check, convex hull, (integer) affine hull, integer 
projection, and computing the lexicographic minimum using parametric integer programming. 

It also includes an ILP solver based on generalized basis reduction. 

ISL is released under LGPLv2.1"

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="ftp://gcc.gnu.org/pub/gcc/infrastructure/$pkg_file"
pkg_opts="configure"
pkg_reqs="gmp/latest pip/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/gmp/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/gmp/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/pip/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/pip/latest/lib"

pkg_cfg="--with-gmp=$BLDR_LOCAL_PATH/numerics/gmp/latest"
pkg_cfg="$pkg_cfg --with-piplib=$BLDR_LOCAL_PATH/numerics/pip/latest"
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
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"


