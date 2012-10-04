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

pkg_vers_dft="3.0"
pkg_vers_list=("$pkg_vers_dft")
pkg_vers_file=("libedit-20120601-3.0.tar.gz")
pkg_vers_urls=("http://www.thrysoee.dk/editline/libedit-20120601-3.0.tar.gz")

pkg_info="This is an autotool- and lib-toolized port of the NetBSD Editline library (libedit)"

pkg_desc="This is an autotool- and lib-toolized port of the NetBSD Editline library (libedit). 

This Berkeley-style licensed command line editor library provides generic line editing, history, 
and tokenization functions, similar to those found in GNU Readline."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="zlib"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file=${pkg_vers_files[$pkg_idx]}
    pkg_urls=${pkg_vers_urls[$pkg_idx]}

    bldr_register_pkg                \
        --category    "$pkg_ctry"    \
        --name        "$pkg_name"    \
        --version     "$pkg_vers"    \
        --default     "$pkg_vers_dft"\
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
