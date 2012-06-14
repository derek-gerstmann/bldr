#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="libtool"
pkg_vers="2.4.2"

pkg_info="GNU libtool is a generic library support script."

pkg_desc="GNU libtool is a generic library support script. 

Libtool hides the complexity of using shared libraries behind a consistent, portable interface. 

To use libtool, add the new generic library building commands to your Makefile, Makefile.in, 
or Makefile.am. See the documentation for details."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftpmirror.gnu.org/libtool/$pkg_file"
pkg_opts="configure force-static"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs="m4/latest autoconf/latest automake/latest"
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
