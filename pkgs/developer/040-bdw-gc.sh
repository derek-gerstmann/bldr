#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="bdw-gc"
pkg_vers="7.2c"
pkg_info="The Boehm-Demers-Weiser conservative garbage collector (GC) can be used as a garbage collecting replacement for C malloc or C++ new."

pkg_desc="The Boehm-Demers-Weiser conservative garbage collector can be used as a 
garbage collecting replacement for C malloc or C++ new. It allows you to allocate 
memory basically as you normally would, without explicitly deallocating memory that 
is no longer useful. The collector automatically recycles memory when it determines 
that it can no longer be otherwise accessed. "

pkg_file="gc-$pkg_vers.tar.gz"
pkg_urls="http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/$pkg_file"
pkg_opts="configure"
pkg_reqs="pkg-config/latest zlib/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib:-lz"

pkg_cfg=""
pkg_patch=""

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
               --patch       "$pkg_patch"   \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

