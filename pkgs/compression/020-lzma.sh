#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="lzma"
pkg_vers="9.20"

pkg_info="LZMA is the default and general compression method of 7z format in the 7-Zip program."

pkg_desc="LZMA is the default and general compression method of 7z format in the 7-Zip program. 

LZMA provides a high compression ratio and very fast decompression, so it is very suitable 
for embedded applications. For example, it can be used for ROM (firmware) compressing."

pkg_file="lzma920.tar.bz2"
pkg_urls="http://downloads.sourceforge.net/sevenzip/$pkg_file"
pkg_opts="configure"
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path="CPP/7zip"

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_src"


