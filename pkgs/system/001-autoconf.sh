#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="autoconf"
pkg_vers="2.68"
pkg_base="autoconf-2.68"
pkg_file="$pkg_base.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/autoconf/$pkg_file"

pkg_opt="configure:keep"
pkg_cflags=0
pkg_ldflags=0
pkg_cfg="--disable-shared --enable-static"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg $pkg_name $pkg_vers $pkg_base $pkg_file $pkg_urls $pkg_opt $pkg_cflags $pkg_ldflags $pkg_cfg

