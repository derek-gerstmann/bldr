#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="1.1.0"
pkg_ctry="databases"
pkg_name="cachestore"
pkg_info="CacheStore is a low-latency storage engine for Project Voldemort."

pkg_desc="CacheStore is a low-latency storage engine for Project Voldemort."

pkg_file="$pkg_name-$pkg_vers.jar"
# pkg_urls="svn://cachestore.googlecode.com/svn/trunk"
pkg_urls="http://cachestore.googlecode.com/files/voldemort-cachestore-1.1.0.jar"
pkg_opts="configure skip-config skip-build migrate-build-tree"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# build and install each pkg version as local module
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


