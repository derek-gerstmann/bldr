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

pkg_vers_dft="0.8.4"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure force-bootstrap enable-shared enable-static"
pkg_reqs="gmp isl zlib"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_vers_dft"   \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg="$pkg_cfg --with-gmp=\"$BLDR_GMP_PATH\""
pkg_cfg="$pkg_cfg --with-isl=\"$BLDR_ISL_PATH\""

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.lri.fr/~bastoul/development/openscop/docs/$pkg_file"

    bldr_register_pkg                \
        --category    "$pkg_ctry"    \
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
        --config      "$pkg_cfg"     \
        --config-path "$pkg_cfg_path"
done

####################################################################################################

