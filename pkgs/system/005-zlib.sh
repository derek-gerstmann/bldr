#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="zlib"
pkg_vers="1.2.7"
pkg_base="zlib-1.2.7"
pkg_file="$pkg_base.tar.gz"
pkg_urls="http://zlib.net/$pkg_file"

pkg_opt="configure:keep"
pkg_cflags=0
pkg_ldflags=0
pkg_cfg="-t -64"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg $pkg_name $pkg_vers $pkg_base $pkg_file $pkg_urls $pkg_opt $pkg_cflags $pkg_ldflags $pkg_cfg


