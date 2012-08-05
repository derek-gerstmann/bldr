#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="osl"
pkg_vers="0.8.4"
pkg_info="The OpenScop Library (OSL) is a BSD-Licensed implementation of the OpenScop specification data format."

pkg_desc="OpenScop is an open specification defining a file format and a set of data 
structures to represent a static control part (SCoP for short), i.e., a program part 
that can be represented in the polyhedral model. The goal of OpenScop is to provide a 
common interface to various polyhedral compilation tools in order to simplify their 
interaction. The OpenScop aim is to provide a stable, unified format that offers a 
durable guarantee that a tool can use an output or provide an input to another tool 
without breaking a tool chain because of some internal changes in one element of the 
chain. The other promise of OpenScop is the ability to assemble or replace the basic 
blocks of a polyhedral compilation framework at no, or at least low engineering cost. 
The OpenScop Library, a.k.a. osl, is an example implementation of the specification 
licensed under the 3-clause BSD licence so developers may feel free to use it in 
their code (either by linking it or copy-pasting its code)."

osl-0.8.4.tar.gz
pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.lri.fr/~bastoul/development/openscop/docs/$pkg_file"
pkg_opts="configure force-bootstrap"

pkg_reqs="gmp/latest isl/latest"
pkg_uses="tar/latest tcl/latest m4/latest autoconf/latest automake/latest $pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/gmp/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/gmp/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/isl/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/isl/latest/lib"

pkg_cfg="--with-gmp=$BLDR_LOCAL_PATH/numerics/gmp/latest"
pkg_cfg="$pkg_cfg --with-isl=$BLDR_LOCAL_PATH/numerics/isl/latest"
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

