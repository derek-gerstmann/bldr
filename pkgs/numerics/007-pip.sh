#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="pip"
pkg_vers="1.4.0"
pkg_info="PIP is software that finds the lexicographic minimum (or maximum) in the set of integer points belonging to a convex polyhedron."

pkg_desc="PIP is software that finds the lexicographic minimum (or maximum) in the set 
of integer points belonging to a convex polyhedron. The very big difference with well 
known integer programming tools like lp_solve or CPLEX is the polyhedron may depend 
linearly on one or more integral parameters. If the user asks for a non integral solution, 
PIP can give the exact solution as an integral quotient. The heart of PIP is the 
parametrized Gomory's cuts algorithm followed by the parameterized dual simplex method. 

The PIP Library (PipLib for short) was implemented to allow the user to call PIP directly 
from his programs, without file accesses or system calls. The user only needs to link 
his programs with C libraries."

pkg_file="piplib-$pkg_vers.tar.gz"
pkg_urls="http://www.bastoul.net/cloog/pages/download/count.php3?url=./$pkg_file"
pkg_opts="configure force-bootstrap"

pkg_reqs="gmp/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/gmp/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/gmp/latest/lib"

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

