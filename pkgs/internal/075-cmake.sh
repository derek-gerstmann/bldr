#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="cmake"

pkg_info="CMake is a family of tools designed to build, test and package software."

pkg_desc="CMake is a family of tools designed to build, test and package software. 
CMake is used to control the software compilation process using simple platform 
and compiler independent configuration files. CMake generates native makefiles 
and workspaces that can be used in the compiler environment of your choice. "

pkg_vers_dft="2.8.9"
pkg_vers_list=("2.6.4" "$pkg_vers_dft")
pkg_vers_urls=("http://www.cmake.org/files/v2.6" "http://www.cmake.org/files/v2.8")

pkg_opts="configure force-static force-bootstrap skip-config"
pkg_uses=""
pkg_uses="$pkg_uses coreutils"
pkg_uses="$pkg_uses findutils"
pkg_uses="$pkg_uses diffutils"
pkg_uses="$pkg_uses patch"
pkg_uses="$pkg_uses sed"
pkg_uses="$pkg_uses grep"
pkg_uses="$pkg_uses tar"
pkg_uses="$pkg_uses m4"
pkg_uses="$pkg_uses autoconf"
pkg_uses="$pkg_uses automake"
pkg_uses="$pkg_uses pkg-config"
pkg_uses="$pkg_uses make"
pkg_reqs="$pkg_uses"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_host="${pkg_vers_url[$pkg_idx]}"
     pkg_urls="$pkg_host/$pkg_file"

     bldr_register_pkg                \
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

     let pkg_idx++     
done

####################################################################################################

