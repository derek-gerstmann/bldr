#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="gperf"
pkg_vers="3.0.4"

pkg_info="GNU gperf is a perfect hash function generator."

pkg_desc="GNU gperf is a perfect hash function generator. For a given list of strings, 
it produces a hash function and hash table, in form of C or C++ code, for looking up a 
value depending on the input string. The hash function is perfect, which means that 
the hash table has no collisions, and the hash table lookup needs a single string 
comparison only.

GNU gperf is highly customizable. There are options for generating C or C++ code, 
for emitting switch statements or nested ifs instead of a hash table, and for 
tuning the algorithm employed by gperf.

Online Manual is available at www.gnu.org/software/gperf/manual/gperf.html"

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/pub/gnu/$pkg_name/$pkg_file"
pkg_opts="configure force-static"
pkg_uses="coreutils/latest"
pkg_reqs="coreutils/latest"
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


