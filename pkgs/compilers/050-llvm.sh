#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="llvm"
pkg_vers="3.1"
pkg_info="The LLVM Core libraries provide a modern source- and target-independent optimizer, along with code generation support for many popular CPUs (as well as some less common ones!)."

pkg_desc="The LLVM Core libraries provide a modern source- and target-independent optimizer, along 
with code generation support for many popular CPUs (as well as some less common ones!) These 
libraries are built around a well specified code representation known as the LLVM intermediate 
representation (LLVM IR).

The LLVM Project is a collection of modular and reusable compiler and toolchain technologies. 
Despite its name, LLVM has little to do with traditional virtual machines, though it does provide 
helpful libraries that can be used to build them.

LLVM began as a research project at the University of Illinois, with the goal of providing a modern, 
SSA-based compilation strategy capable of supporting both static and dynamic compilation of arbitrary 
programming languages. Since then, LLVM has grown to be an umbrella project consisting of a number of 
different subprojects, many of which are being used in production by a wide variety of commercial 
and open source projects as well as being widely used in academic research. Code in the LLVM project 
is licensed under the UIUC BSD-Style license."

pkg_file="$pkg_name-$pkg_vers.src.tar.gz"
pkg_urls="http://llvm.org/releases/$pkg_vers/$pkg_file"
pkg_opts="configure -MBUILD_EXAMPLES=0"
pkg_reqs="libffi/latest"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--enable-optimized --enable-jit --enable-targets=all --enable-libffi" 

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


