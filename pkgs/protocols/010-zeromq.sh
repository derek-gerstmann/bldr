#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="zeromq"

pkg_info="ZeroMQ provides components for building scalable and high performance distributed applications"

pkg_desc="ZeroMQ looks like an embeddable networking library but acts like a concurrency 
framework. It gives you sockets that carry whole messages across various transports like in-process, 
inter-process, TCP, and multicast. You can connect sockets N-to-N with patterns like fanout, pub-sub, 
task distribution, and request-reply. It's fast enough to be the fabric for clustered products. 
Its asynchronous I/O model gives you scalable multicore applications, built as asynchronous 
message-processing tasks. It has a score of language APIs and runs on most operating systems. 
ØMQ is from iMatix and is LGPL open source."

pkg_vers_dft="2.2.0"
pkg_vers_list=("2.1.7" "2.2.0" "3.2.0-rc1")

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$zmq_vers.tar.gz"
     pkg_urls="http://download.zeromq.org/$pkg_file"

     bldr_register_pkg                  \
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
done

####################################################################################################

