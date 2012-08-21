#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="cloog"
pkg_vers="0.17.0"
pkg_info="CLooG is a free software and library to generate code for scanning Z-polyhedra."

pkg_desc="CLooG is a free software and library to generate code for scanning Z-polyhedra. 
That is, it finds a code (e.g. in C, FORTRAN...) that reaches each integral point of one 
or more parameterized polyhedra. CLooG has been originally written to solve the code 
generation problem for optimizing compilers based on the polytope model. Nevertheless 
it is used now in various area e.g. to build control automata for high-level synthesis 
or to find the best polynomial approximation of a function. CLooG may help in any situation 
where scanning polyhedra matters. While the user has full control on generated code quality,
 CLooG is designed to avoid control overhead and to produce a very effective code.

CLooG stands for Chunky Loop Generator: it is a part of the Chunky project, a research tool 
for data locality improvement. It is designed to be also the back-end of automatic parallelizers 
like LooPo. Thus it is very 'compilable code oriented' and provides powerful program 
transformation facilities. Mainly, it allows the user to specify very general schedules, 
e.g. where unimodularity or invertibility doesn't matter."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.bastoul.net/cloog/pages/download/count.php3?url=./$pkg_file"
pkg_opts="configure force-bootstrap"

pkg_reqs=""
pkg_reqs="$pkg_reqs gmp/latest"
pkg_reqs="$pkg_reqs isl/latest"
pkg_reqs="$pkg_reqs osl/latest"
pkg_reqs="$pkg_reqs zlib/latest"
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

pkg_cfg=""
pkg_cfg="$pkg_cfg --with-bits=gmp"
pkg_cfg="$pkg_cfg --with-gmp=\"$BLDR_GMP_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-isl=\"$BLDR_ISL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-osl=\"$BLDR_OSL_BASE_PATH\""

pkg_cflags=""
pkg_ldflags=""
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

