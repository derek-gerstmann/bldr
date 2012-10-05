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

pkg_info="LZMA is the default and general compression method of 7z format in the 7-Zip program."

pkg_desc="LZMA is the default and general compression method of 7z format in the 7-Zip program. 

LZMA provides a high compression ratio and very fast decompression, so it is very suitable 
for embedded applications. For example, it can be used for ROM (firmware) compressing."

pkg_default="9.20"
pkg_variants=("9.20")
pkg_distribs=("lzma920.tar.bz2")
pkg_mirrors=("http://downloads.sourceforge.net/sevenzip/lzma920.tar.bz2")

pkg_opts="configure"
pkg_uses=""
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path="CPP/7zip"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file=${pkg_distribs[$pkg_idx]}
    pkg_urls=${pkg_mirrors[$pkg_idx]}

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

    let pkg_idx++
done

####################################################################################################
