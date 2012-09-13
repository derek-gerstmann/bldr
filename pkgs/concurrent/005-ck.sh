#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="concurrent"
pkg_name="ck"
pkg_vers="0.2.9"
pkg_info="Concurrency Kit provides a plethora of concurrency primitives for high-performance concurrent systems."

pkg_desc="Concurrency Kit provides a plethora of concurrency primitives, safe memory reclamation 
mechanisms and lock-less and lock-free data structures designed to aid in the design and 
implementation of high performance concurrent systems. It is designed to minimize dependencies 
on operating system-specific interfaces and most of the interface relies only on a strict subset 
of the standard library and more popular compiler extensions."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.concurrencykit.org/releases/$pkg_file"
pkg_opts="configure skip-xcode-config"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                    \
     --category    "$pkg_ctry"    \
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


