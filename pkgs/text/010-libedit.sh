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

pkg_default="3.0"
pkg_variants=("3.0")
pkg_distribs=("libedit-20120601-3.0.tar.gz")
pkg_mirrors=("http://www.thrysoee.dk/editline/libedit-20120601-3.0.tar.gz")

pkg_info="This is an autotool- and lib-toolized port of the NetBSD Editline library (libedit)"

pkg_desc="This is an autotool- and lib-toolized port of the NetBSD Editline library (libedit). 

This Berkeley-style licensed command line editor library provides generic line editing, history, 
and tokenization functions, similar to those found in GNU Readline."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_reqs="zlib"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

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
