#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="cmake"
pkg_vers="2.8.8"

pkg_info="CMake is a family of tools designed to build, test and package software."

pkg_desc="CMake is a family of tools designed to build, test and package software. 
CMake is used to control the software compilation process using simple platform 
and compiler independent configuration files. CMake generates native makefiles 
and workspaces that can be used in the compiler environment of your choice. "

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.cmake.org/files/v2.8/$pkg_file"
pkg_opts="configure force-static force-bootstrap skip-config"
pkg_uses="coreutils/latest m4/latest autoconf/latest automake/latest libtool/latest"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "internal"     \
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
               --config      "$pkg_cfg"     


