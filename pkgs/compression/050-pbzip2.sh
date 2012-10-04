#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="pbzip2"

pkg_info="PBZIP2 is a parallel implementation of the bzip2 block-sorting file compressor."

pkg_desc="PBZIP2 is a parallel implementation of the bzip2 block-sorting file compressor 
that uses pthreads and achieves near-linear speedup on SMP machines. The output of this 
version is fully compatible with bzip2 v1.0.2 or newer (ie: anything compressed with pbzip2 
can be decompressed with bzip2). PBZIP2 should work on any system that has a pthreads 
compatible C++ compiler (such as gcc). It has been tested on: Linux, Windows 
(cygwin & MinGW), Solaris, Tru64/OSF1, HP-UX, OS/2, and Irix."

pkg_vers_dft="1.1.6"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure migrate-build-binaries skip-install"
pkg_uses="m4 autoconf automake"
pkg_reqs="zlib"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://compression.ca/pbzip2/$pkg_file"

     bldr_register_pkg                 \
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


