#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="spatial"
pkg_name="nanoflann"
pkg_vers="1.1.3"

pkg_info="NanoFLANN is a C++ header-only library for building KD-Trees, mostly optimized for 2D or 3D point clouds."

pkg_desc="NanoFLANN is a C++ header-only library for building KD-Trees, mostly optimized 
for 2D or 3D point clouds.

nanoflann does not require compiling or installing, just an #include <nanoflann.hpp> in your code.

This library is a fork (and a subset) of the flann library, by Marius Muja and David G. Lowe, 
born as a child project of MRPT. Following the original license terms, nanoflann is distributed 
under the BSD license."

pkg_opts="cmake"
pkg_uses="eigen"
pkg_reqs="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                   \
  --category    "$pkg_ctry"        \
  --name        "$pkg_name"        \
  --version     "$pkg_vers_dft"    \
  --requires    "$pkg_reqs"        \
  --uses        "$pkg_uses"        \
  --options     "$pkg_opts"

####################################################################################################

pkg_cfg="-DEIGEN3_INCLUDE_PATH=\"$BLDR_EIGEN_INCLUDE_PATH\""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://nanoflann.googlecode.com/files/$pkg_file"

    bldr_register_pkg                  \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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
