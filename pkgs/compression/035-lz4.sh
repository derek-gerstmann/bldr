#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="lz4"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="LZ4 is a very fast lossless compression algorithm."

pkg_desc="LZ4 is a very fast lossless compression algorithm, providing compression 
speed at 300 MB/s per core, scalable with multi-cores CPU. It also features an extremely fast 
decoder, with speeds up and beyond 1GB/s per core, typically reaching RAM speed limits on 
multi-core systems."

pkg_opts="cmake enable-static enable-shared"
pkg_uses="cmake"
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path="cmake"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
     pkg_urls="svn://lz4.googlecode.com/svn/trunk"

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


