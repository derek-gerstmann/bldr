#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="ppl"
pkg_vers="1.0"
pkg_info="The Parma Polyhedra Library (PPL) provides numerical abstractions especially targeted at applications in the field of analysis and verification of complex systems."

pkg_desc="The Parma Polyhedra Library (PPL) provides numerical abstractions especially 
targeted at applications in the field of analysis and verification of complex systems. 
These abstractions include convex polyhedra, defined as the intersection of a finite 
number of (open or closed) halfspaces, each described by a linear inequality (strict 
or non-strict) with rational coefficients; some special classes of polyhedra shapes 
that offer interesting complexity/precision tradeoffs; and grids which represent regularly 
spaced points that satisfy a set of linear congruence relations. The library also supports 
finite powersets and products of (any kind of) polyhedra and grids, a mixed integer linear 
programming problem solver using an exact-arithmetic version of the simplex algorithm, 
a parametric integer programming solver, and primitives for termination analysis via 
the automatic synthesis of linear ranking functions. More details are available on the 
PPL's internal mechanisms.)"

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://bugseng.com/products/ppl/download/ftp/releases/$pkg_vers/$pkg_file"
pkg_opts="configure"
pkg_reqs="gmp/latest"
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

pkg_cfg="--with-gmp=\"$BLDR_GMP_BASE_PATH\""
pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

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

