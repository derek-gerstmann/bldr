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
pkg_vers="0.1.0"

pkg_info="BusyBee provides a messaging abstraction on top of TCP sockets."
pkg_desc="BusyBee provides a messaging abstraction on top of TCP sockets.

BusyBee is a refined version of the HyperDex event loop.  It exposes a
messaging abstraction on top of TCP and automatically packs/unpacks messages
on the wire.  At the core of BusyBee is a thread-safe event loop that enables
multiple threads to send and receive messages concurrently."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://hyperdex.org/src/$pkg_file"
pkg_opts="configure"
pkg_reqs="pkg-config/latest zlib/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

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
               --patch       "$pkg_patch"   \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

