#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="libarchive"

pkg_default="3.0.4"
pkg_variants=("3.0.4")

pkg_info="Libarchive is an open-source BSD-licensed C programming library that provides streaming access to a variety of different archive formats, including tar, cpio, pax, Zip, and ISO9660 images."

pkg_desc="Libarchive is an open-source BSD-licensed C programming library that provides 
streaming access to a variety of different archive formats, including tar, cpio, pax, Zip, 
and ISO9660 images.

The distribution also includes bsdtar and bsdcpio, full-featured implementations of tar 
and cpio that use libarchive."

pkg_opts="configure"
pkg_uses="m4 autoconf automake"

pkg_reqs="zlib "
pkg_reqs+="gzip "
pkg_reqs+="bzip2 "
pkg_reqs+="xz "
pkg_reqs+="lzo "
pkg_reqs+="openssl "

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="https://github.com/downloads/libarchive/libarchive/$pkg_file"

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


