#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="lzo"
pkg_vers="2.06"

pkg_info="LZO is a data compression library which is suitable for data de-/compression in real-time."

pkg_desc="LZO is a data compression library which is suitable for data de-/compression 
in real-time. This means it favours speed over compression ratio.

LZO is written in ANSI C. Both the source code and the compressed data format are designed 
to be portable across platforms.

LZO implements a number of algorithms with the following features:

* Decompression is simple and *very* fast.
* Requires no memory for decompression.
* Compression is pretty fast.
* Requires 64 kB of memory for compression.
* Allows you to dial up extra compression at a speed cost in the compressor. The speed of the decompressor is not reduced.
* Includes compression levels for generating pre-compressed data which achieve a quite competitive compression ratio.
* There is also a compression level which needs only 8 kB for compression.
* Algorithm is thread safe.
* Algorithm is lossless.

LZO supports overlapping compression and in-place decompression.

LZO and the LZO algorithms and implementations are distributed under the terms of the 
GNU General Public License (GPL) ."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.oberhumer.com/opensource/lzo/download/$pkg_file"
pkg_opts="configure"
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_src"


