#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="scipy"

pkg_default="0.11.0"
pkg_variants=("0.11.0")

pkg_info="SciPy is an open-source software python library for mathematics, science, and engineering."

pkg_desc="SciPy is an open-source software python library for mathematics, science, and engineering.

The SciPy library depends on NumPy, which provides convenient and fast N-dimensional array manipulation. 

The SciPy library is built to work with NumPy arrays, and provides many user-friendly and efficient 
numerical routines such as routines for numerical integration and optimization. Together, they 
run on all popular operating systems, are quick to install, and are free of charge. NumPy and 
SciPy are easy to use, but powerful enough to be depended upon by some of the world's leading 
scientists and engineers."

pkg_opts="python skip-compile skip-install"
pkg_reqs="python lapack atlas gfortran numpy"
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
    pkg_urls="http://downloads.sourceforge.net/project/$pkg_name/scipy/$pkg_vers/$pkg_file"

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
