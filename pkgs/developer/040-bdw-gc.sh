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

pkg_default="7.2c"
pkg_variants=("7.2c")

pkg_info="The Boehm-Demers-Weiser conservative garbage collector (GC) can be used as a garbage collecting replacement for C malloc or C++ new."

pkg_desc="The Boehm-Demers-Weiser conservative garbage collector can be used as a 
garbage collecting replacement for C malloc or C++ new. It allows you to allocate 
memory basically as you normally would, without explicitly deallocating memory that 
is no longer useful. The collector automatically recycles memory when it determines 
that it can no longer be otherwise accessed. "

pkg_opts="configure enable-static enable-shared"
pkg_reqs="pkg-config zlib"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="gc-$pkg_vers.tar.gz"
     pkg_urls="http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/$pkg_file"

     bldr_register_pkg                \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_default" \
         --info        "$pkg_info"    \
         --description "$pkg_desc"    \
         --file        "$pkg_file"    \
         --url         "$pkg_urls"    \
         --uses        "$pkg_uses"    \
         --requires    "$pkg_reqs"    \
         --options     "$pkg_opts"    \
         --cflags      "$pkg_cflags"  \
         --ldflags     "$pkg_ldflags" \
         --config      "$pkg_cfg"     \
         --config-path "$pkg_cfg_path"
done

####################################################################################################
