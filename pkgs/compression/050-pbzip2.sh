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
pkg_vers="1.1.6"

pkg_info="PBZIP2 is a parallel implementation of the bzip2 block-sorting file compressor."

pkg_desc="PBZIP2 is a parallel implementation of the bzip2 block-sorting file compressor 
that uses pthreads and achieves near-linear speedup on SMP machines. The output of this 
version is fully compatible with bzip2 v1.0.2 or newer (ie: anything compressed with pbzip2 
can be decompressed with bzip2). PBZIP2 should work on any system that has a pthreads 
compatible C++ compiler (such as gcc). It has been tested on: Linux, Windows 
(cygwin & MinGW), Solaris, Tru64/OSF1, HP-UX, OS/2, and Irix."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://compression.ca/pbzip2/$pkg_file"
pkg_opts="configure migrate-build-binaries skip-install"
pkg_uses=""
pkg_reqs="zlib/latest"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags="$pkg_cflags -fPIC"
fi

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

