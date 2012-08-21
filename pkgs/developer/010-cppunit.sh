#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="cppunit"
pkg_vers="1.12.1"
pkg_info="CppUnit is a C++ unit testing framework."

pkg_desc="CppUnit is a C++ unit testing framework. It started its life as a port of JUnit to C++ by Michael Feathers."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://downloads.sourceforge.net/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs="coreutils/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                    \
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
     --patch       "$pkg_patch"   \
     --cflags      "$pkg_cflags"  \
     --ldflags     "$pkg_ldflags" \
     --config      "$pkg_cfg"

