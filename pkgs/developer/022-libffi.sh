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

pkg_default="3.0.11"
pkg_variants=("3.0.11")

pkg_info="The libffi library provides a portable, high level programming interface to various calling conventions."

pkg_desc="The libffi library provides a portable, high level programming interface to various 
calling conventions. This allows a programmer to call any function specified by a call 
interface description at run-time.

FFI stands for Foreign Function Interface. A foreign function interface is the popular 
name for the interface that allows code written in one language to call code written in 
another language. The libffi library really only provides the lowest, machine dependent 
layer of a fully featured foreign function interface. A layer must exist above libffi 
that handles type conversions for values passed between the two languages."

pkg_opts="configure enable-static enable-shared"

pkg_reqs="zlib libiconv"
pkg_uses="$pkg_reqs"

pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://sourceware.mirrors.tds.net/pub/sourceware.org/libffi/$pkg_file"

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
