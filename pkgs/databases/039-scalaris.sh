#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="scalaris"

pkg_default="0.5.0"
pkg_variants=("0.5.0")

pkg_info="Scalaris is a Distributed Transactional Key-Value Store."

pkg_desc="Scalaris is a Distributed Transactional Key-Value Store.

Scalaris uses a structured overlay with a non-blocking Paxos commit protocol for 
transaction processing with strong consistency over replicas. Scalaris is 
implemented in Erlang. "

pkg_opts="configure enable-static enable-shared"
pkg_cfg=""

pkg_reqs="libtool "
pkg_reqs+="erlang "
pkg_uses="$pkg_reqs"

pkg_cflags="-lm"
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
      pkg_file="$pkg_name-$pkg_vers.tar.gz"
      pkg_urls="http://scalaris.googlecode.com/files/$pkg_file"
      
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
