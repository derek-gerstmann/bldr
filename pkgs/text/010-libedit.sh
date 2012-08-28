#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="libedit"
pkg_vers="3.0"
pkg_info="This is an autotool- and lib-toolized port of the NetBSD Editline library (libedit)"

pkg_desc="This is an autotool- and lib-toolized port of the NetBSD Editline library (libedit). 

This Berkeley-style licensed command line editor library provides generic line editing, history, 
and tokenization functions, similar to those found in GNU Readline."

pkg_file="libedit-20120601-3.0.tar.gz"
pkg_urls="http://www.thrysoee.dk/editline/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest"
pkg_uses="$pkg_reqs"
pkg_cfg="--enable-static --enable-shared"
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags="$pkg_cflags -fPIC"
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "$pkg_ctry"    \
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


