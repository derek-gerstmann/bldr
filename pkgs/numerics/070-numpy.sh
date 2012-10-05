#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="numpy"

pkg_default="1.6.2"
pkg_variants=("1.6.2" "1.7.0b2")

pkg_info="NumPy is the fundamental package for scientific computing with Python."

pkg_desc="NumPy is the fundamental package for scientific computing with Python.

It contains among other things:

- a powerful N-dimensional array object
- sophisticated (broadcasting) functions
- tools for integrating C/C++ and Fortran code
- useful linear algebra, Fourier transform, and random number capabilities
- Besides its obvious scientific uses, NumPy can also be used as an efficient multi-dimensional container of generic data. Arbitrary data-types can be defined. 

This allows NumPy to seamlessly and speedily integrate with a wide variety of databases.

Numpy is licensed under the BSD license, enabling reuse with few restrictions."

pkg_opts="python skip-compile skip-install"
pkg_reqs="python lapack atlas gfortran"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                     \
    --category    "$pkg_ctry"        \
    --name        "$pkg_name"        \
    --version     "$pkg_default"     \
    --requires    "$pkg_reqs"        \
    --uses        "$pkg_uses"        \
    --options     "$pkg_opts"

####################################################################################################

export ATLAS=$BLDR_ATLAS_LIB_PATH/libatlas.a 
export LAPACK=$BLDR_ATLAS_LIB_PATH/liblapack.a
export BLAS=$BLDR_ATLAS_LIB_PATH/libptcblas.a

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://downloads.sourceforge.net/project/$pkg_name/NumPy/$pkg_vers/$pkg_file"

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
