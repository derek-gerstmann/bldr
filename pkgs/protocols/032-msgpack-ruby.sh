#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="msgpack-ruby"
pkg_vers="0.4.7"
pkg_info="Ruby bindings for MessagePack -- an efficient binary serialization format."

pkg_desc="Ruby bindings for MessagePack -- an efficient binary serialization format."

pkg_file="msgpack-$pkg_vers.gem"
pkg_urls="http://rubygems.org/downloads/$pkg_file"
pkg_opts="ruby use-gem"
pkg_reqs=""
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

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


