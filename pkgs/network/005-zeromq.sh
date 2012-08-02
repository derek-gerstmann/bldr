#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="zeromq"
pkg_vers="3.2.0-rc1"
pkg_info="ZeroMQ provides components for building scalable and high performance distributed applications"

pkg_desc="ZeroMQ looks like an embeddable networking library but acts like a concurrency 
framework. It gives you sockets that carry whole messages across various transports like in-process, 
inter-process, TCP, and multicast. You can connect sockets N-to-N with patterns like fanout, pub-sub, 
task distribution, and request-reply. It's fast enough to be the fabric for clustered products. 
Its asynchronous I/O model gives you scalable multicore applications, built as asynchronous 
message-processing tasks. It has a score of language APIs and runs on most operating systems. 
ØMQ is from iMatix and is LGPL open source."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://download.zeromq.org/$pkg_file"
pkg_opts="configure"
pkg_reqs=""
pkg_uses="tar/latest m4/latest autoconf/latest automake/latest $pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "network"      \
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


