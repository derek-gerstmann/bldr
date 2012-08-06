#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="protobuf"
pkg_vers="2.4.1"
pkg_info="Protocol buffers are a flexible, efficient, automated mechanism for serializing structured data."

pkg_desc="Protocol buffers are a flexible, efficient, automated mechanism for serializing 
structured data – think XML, but smaller, faster, and simpler. You define how you want 
your data to be structured once, then you can use special generated source code to easily
write and read your structured data to and from a variety of data streams and using a 
variety of languages. You can even update your data structure without breaking deployed 
programs that are compiled against the old format."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://protobuf.googlecode.com/files/$pkg_file"
pkg_opts="configure"
pkg_reqs="python/2.7.3"
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


