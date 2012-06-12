#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="gzip"
pkg_vers="1.4"

pkg_info="GNU zip is a compression utility designed to be a replacement for compress."

pkg_desc="GNU zip is a compression utility designed to be a replacement for compress.  Its 
main advantages over compress are much better compression and freedom from patented algorithms. 
It has been adopted by the GNU project and is now relatively popular on the Internet."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/gzip/$pkg_file"
pkg_opts="configure force-static"
pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "system"       \
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

