#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="automake"
pkg_vers="1.11.5"

pkg_info="Automake is a Makefile generator."

pkg_desc="Automake is a Makefile generator.  It was inspired by the 4.4BSD 
make and include files, but aims to be portable and to conform to the 
GNU Coding Standards for Makefile variables and targets."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/automake/$pkg_file"
pkg_reqs="m4/latest"
pkg_opts="configure:keep"
pkg_cflags=0
pkg_ldflags=0
pkg_cfg="--disable-shared --enable-static"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg "$pkg_name"    \
               "$pkg_vers"    \
               "$pkg_info"    \
               "$pkg_desc"    \
               "$pkg_file"    \
               "$pkg_urls"    \
               "$pkg_reqs"    \
               "$pkg_opts"    \
               "$pkg_cflags"  \
               "$pkg_ldflags" \
               "$pkg_cfg"

