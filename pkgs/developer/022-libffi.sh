#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="libffi"
pkg_vers="3.0.11"
pkg_info="The libffi library provides a portable, high level programming interface to various calling conventions."

pkg_desc="The libffi library provides a portable, high level programming interface to various 
calling conventions. This allows a programmer to call any function specified by a call 
interface description at run-time.

FFI stands for Foreign Function Interface. A foreign function interface is the popular 
name for the interface that allows code written in one language to call code written in 
another language. The libffi library really only provides the lowest, machine dependent 
layer of a fully featured foreign function interface. A layer must exist above libffi 
that handles type conversions for values passed between the two languages."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://sourceware.mirrors.tds.net/pub/sourceware.org/libffi/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest libiconv/latest"
pkg_uses="$pkg_reqs"
pkg_cfg="--enable-static --enable-shared"
pkg_cflags=""
pkg_ldflags=""

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


