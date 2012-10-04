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

pkg_info="ISPC is a compiler for a variant of the C programming language, with extensions for single program, multiple data programming."

pkg_desc="ISPC is a compiler for a variant of the C programming language, with extensions 
for single program, multiple data programming. Under the SPMD model, the programmer writes 
a program that generally appears to be a regular serial program, though the execution model 
is actually that a number of program instances execute in parallel on the hardware."

pkg_vers_dft="1.3.0"
pkg_vers_list=("$pkg_vers")

pkg_opts="configure migrate-build-binaries migrate-build-tree"
pkg_reqs="bison flex clang"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list}
do
     if [[ $BLDR_SYSTEM_IS_OSX == true ]]
     then
          pkg_file="$pkg_name-v$pkg_vers-osx.tar.gz"
     fi
     if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
     then
          pkg_file="$pkg_name-v$pkg_vers-linux.tar.gz"
     fi

     pkg_urls="https://github.com/downloads/ispc/ispc/$pkg_file"

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

