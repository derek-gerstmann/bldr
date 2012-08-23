#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="pdt"
pkg_vers="3.18"
pkg_info="The Program Database Toolkit contains tools for trace date analysis and instrument profiling."

pkg_desc="The Program Database Toolkit contains tools for trace date analysis and instrument profiling."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://tau.uoregon.edu/pdt.tgz"
pkg_opts="configure"

####################################################################################################

pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="-prefix=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers -GNU"

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

