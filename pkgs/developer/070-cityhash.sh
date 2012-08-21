#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="cityhash"
pkg_vers="1.0.3"

pkg_info="CityHash provides hash functions for strings."

pkg_desc="CityHash provides hash functions for strings. 

The functions mix the input bits thoroughly but are not suitable for cryptography. 
We provide reference implementations in C++, with a friendly MIT license. The code's 
portable; let us know if you encounter problems. 

The README contains a good explanation of the various CityHash functions. However, here is a short summary:

* CityHash64() and similar return a 64-bit hash. Inside Google, where CityHash was developed starting in 2010, we use variants of CityHash64() mainly in hash tables such as hash_map<string, int>.

* CityHash128() and similar return a 128-bit hash and are tuned for strings of at least a few hundred bytes. Depending on your compiler and hardware, it may be faster than CityHash64() on sufficiently long strings. It is known to be slower than necessary on shorter strings, but we expect that case to be relatively unimportant. Inside Google we use variants of CityHash128() mainly for code that wants to minimize collisions.

* CityHashCrc128() and CityHashCrc256() and similar are additional variants, specially tuned for CPUs with SSE4.2."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://cityhash.googlecode.com/files/$pkg_file"
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

