#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="coreutils"
pkg_vers="8.17"

pkg_info="The GNU Core Utilities are the basic file, shell and text manipulation utilities of the GNU operating system. "

pkg_desc="The GNU Core Utilities are the basic file, shell and text manipulation utilities of the GNU operating system. 
These are the core utilities which are expected to exist on every operating system."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://fossies.org/unix/misc/$pkg_file"
pkg_opts="configure force-static"
pkg_uses=""
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


