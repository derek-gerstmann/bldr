#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="busybee"

pkg_default="0.1.0"
pkg_variants=("0.1.0")

pkg_info="BusyBee provides a messaging abstraction on top of TCP sockets."
pkg_desc="BusyBee provides a messaging abstraction on top of TCP sockets.

BusyBee is a refined version of the HyperDex event loop.  It exposes a
messaging abstraction on top of TCP and automatically packs/unpacks messages
on the wire.  At the core of BusyBee is a thread-safe event loop that enables
multiple threads to send and receive messages concurrently."

pkg_opts="configure enable-static enable-shared"

pkg_reqs="pkg-config zlib"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://hyperdex.org/src/$pkg_file"

     bldr_register_pkg                 \
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
