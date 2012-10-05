#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="xz"

pkg_default="5.0.3"
pkg_variants=("5.0.3")

pkg_info="XZ utils is free general-purpose data compression software with high compression ratio."

pkg_desc="XZ utils is free general-purpose data compression software with high compression ratio. 
XZ Utils were written for POSIX-like systems, but also work on some not-so-POSIX systems. 
XZ Utils are the successor to LZMA Utils.

The core of the XZ Utils compression code is based on LZMA SDK, but it has been modified 
quite a lot to be suitable for XZ Utils. The primary compression algorithm is currently LZMA2, 
which is used inside the .xz container format. With typical files, XZ Utils create 30 % smaller 
output than gzip and 15 % smaller output than bzip2. "

pkg_opts="configure force-static"
pkg_uses="m4 autoconf automake"
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://tukaani.org/xz/$pkg_file"

     bldr_register_pkg                 \
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


