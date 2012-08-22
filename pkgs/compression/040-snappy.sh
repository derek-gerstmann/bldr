#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="snappy"
pkg_vers="1.0.5"

pkg_info="Snappy is a compression/decompression library."

pkg_desc="Snappy is a compression/decompression library. It does not aim for maximum compression, 
or compatibility with any other compression library; instead, it aims for very high speeds and 
reasonable compression. For instance, compared to the fastest mode of zlib, Snappy is an order 
of magnitude faster for most inputs, but the resulting compressed files are anywhere from 20% 
to 100% bigger. On a single core of a Core i7 processor in 64-bit mode, Snappy compresses at 
about 250 MB/sec or more and decompresses at about 500 MB/sec or more.

Snappy is widely used inside Google, in everything from BigTable and MapReduce to our internal 
RPC systems. (Snappy has previously been referred to as “Zippy” in some presentations and the 
likes.)

For more information, please see the README. Benchmarks against a few other compression 
libraries (zlib, LZO, LZF, FastLZ, and QuickLZ) are included in the source code 
distribution. The source code also contains a formal format specification, as well as 
a specification for a framing format useful for higher-level framing and encapsulation 
of Snappy data, e.g. for transporting Snappy-compressed data across HTTP in a streaming 
fashion. Note that there is currently no known code implementing the latter."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://snappy.googlecode.com/files/$pkg_file"
pkg_opts="configure"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

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

