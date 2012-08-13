#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="ispc"
pkg_vers="1.3.0"
pkg_info="ISPC is a compiler for a variant of the C programming language, with extensions for single program, multiple data programming."

pkg_desc="ISPC is a compiler for a variant of the C programming language, with extensions 
for single program, multiple data programming. Under the SPMD model, the programmer writes 
a program that generally appears to be a regular serial program, though the execution model 
is actually that a number of program instances execute in parallel on the hardware."

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_file="$pkg_name-v$pkg_vers-osx.tar.gz"
else
     pkg_file="$pkg_name-v$pkg_vers-linux.tar.gz"
fi

pkg_urls="https://github.com/downloads/ispc/ispc/$pkg_file"
pkg_opts="configure migrate-build-binaries migrate-build-tree"
pkg_reqs="bison/latest flex/latest clang/latest"
pkg_uses="$pkg_reqs"

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


