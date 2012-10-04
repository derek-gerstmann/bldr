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
pkg_info="Concurrency Kit provides a plethora of concurrency primitives for high-performance concurrent systems."

pkg_desc="Concurrency Kit provides a plethora of concurrency primitives, safe memory reclamation 
mechanisms and lock-less and lock-free data structures designed to aid in the design and 
implementation of high performance concurrent systems. It is designed to minimize dependencies 
on operating system-specific interfaces and most of the interface relies only on a strict subset 
of the standard library and more popular compiler extensions."

pkg_vers_dft="0.2.10"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure skip-xcode-config enable-shared enable-static"
pkg_reqs="m4 automake autoconf"
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://www.concurrencykit.org/releases/$pkg_file"

     bldr_register_pkg                \
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


