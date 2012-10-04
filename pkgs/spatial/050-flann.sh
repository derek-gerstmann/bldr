#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="spatial"
pkg_name="flann"

pkg_info="FLANN is a library for performing fast approximate nearest neighbor searches in high dimensional spaces."

pkg_desc="FLANN is a library for performing fast approximate nearest neighbor searches in 
high dimensional spaces. It contains a collection of algorithms we found to work best for 
nearest neighbor search and a system for automatically choosing the best algorithm and 
optimum parameters depending on the dataset. FLANN is written in C++ and contains bindings 
for the following languages: C, MATLAB and Python."

pkg_vers_dft="trunk"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="cmake"
pkg_uses="python"
pkg_reqs="$pkg_reqs"

pkg_cfg="-DBUILD_MATLAB_BINDINGS=OFF"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg_path="build"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.bz2"
     pkg_urls="git://github.com/mariusmuja/flann.git"

     bldr_register_pkg                 \
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
