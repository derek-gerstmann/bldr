#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="concurrent"
pkg_name="atomic-ops"

pkg_info="The Atomic-Ops Library provides implementations for atomic memory update operations on a number of architectures."

pkg_desc="The Atomic-Ops Library provides implementations for atomic memory update operations 
on a number of architectures. This allows direct use of these in reasonably portable 
code. Unlike earlier similar packages, this one explicitly considers memory barrier 
semantics, and allows the construction of code that involves minimum overhead across 
a variety of architectures.

The package has been at least minimally tested on X86, Itanium, Alpha, PA-RISC, 
PowerPC, and SPARC, with Linux, Microsoft Windows, HP/UX, Solaris, and MACOSX 
operating systems. Some implementations are more complete than others.

It should be useful both for high performance multi-threaded code which can't 
afford to use the standard locking primitives, or for code that has to access shared 
data structures from signal handlers. For details, see README.txt in the distribution. "

pkg_vers_dft="7.2d"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enabled-static enable-shared"
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
     pkg_file="libatomic_ops-$pkg_vers.tar.gz"
     pkg_urls="http://www.hpl.hp.com/research/linux/atomic_ops/download/$pkg_file"

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


