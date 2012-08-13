#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="concurrent"
pkg_name="tbb"
pkg_vers="4.0u5"
pkg_info="Intel® Threading Building Blocks (Intel® TBB) offers a rich and complete approach to expressing parallelism in a C++ program."

pkg_desc="Intel® Threading Building Blocks (Intel® TBB) offers a rich and 
complete approach to expressing parallelism in a C++ program.

It is a library that helps you take advantage of multi-core processor performance without 
having to be a threading expert. Intel TBB is not just a threads-replacement library. 
It represents a higher-level, task-based parallelism that abstracts platform details 
and threading mechanisms for scalability and performance. "

pkg_file="tbb40_20120613oss_src.tgz"
pkg_urls="http://threadingbuildingblocks.org/uploads/77/187/4.0%20update%205/$pkg_file"
pkg_opts="configure -ETBBROOT=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

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


