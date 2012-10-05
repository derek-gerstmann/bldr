#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="lapack"

pkg_default="3.4.1"
pkg_variants=("3.4.1")

pkg_info="LAPACK is written in Fortran 90 and provides routines for solving systems of simultaneous linear equations, least-squares solutions of linear systems of equations, eigenvalue problems, and singular value problems."

pkg_desc="LAPACK is written in Fortran 90 and provides routines for solving systems 
of simultaneous linear equations, least-squares solutions of linear systems of 
equations, eigenvalue problems, and singular value problems. The associated matrix 
factorizations (LU, Cholesky, QR, SVD, Schur, generalized Schur) are also provided, 
as are related computations such as reordering of the Schur factorizations and 
estimating condition numbers. Dense and banded matrices are handled, but not 
general sparse matrices. In all areas, similar functionality is provided for 
real and complex matrices, in both single and double precision."

pkg_opts="cmake"
pkg_reqs="gfortran python"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg+=":-DCMAKE_Fortran_COMPILER=\"$BLDR_GFORTRAN_BIN_PATH/gfortran\""
pkg_cfg+=":-DBUILD_SINGLE=ON"
pkg_cfg+=":-DBUILD_COMPLEX=ON"
pkg_cfg+=":-DBUILD_DOUBLE=ON"
pkg_cfg+=":-DBUILD_COMPLEX16=ON"
pkg_cfg+=":-DBUILD_SHARED_LIBS=ON"
pkg_cfg+=":-DBUILD_STATIC_LIBS=ON"
pkg_cfg_path="build"

pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_cflags+="-fPIC "
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tgz"
    pkg_urls="http://www.netlib.org/$pkg_name/$pkg_file"

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
