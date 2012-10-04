#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="valgrind"

pkg_info="Valgrind is an instrumentation framework for building dynamic analysis tools."

pkg_desc="Valgrind is an instrumentation framework for building dynamic analysis tools. 

There are Valgrind tools that can automatically detect many memory management and 
threading bugs, and profile your programs in detail. You can also use Valgrind to 
build new tools.

The Valgrind distribution currently includes six production-quality tools: a memory 
error detector, two thread error detectors, a cache and branch-prediction profiler, 
a call-graph generating cache and branch-prediction profiler, and a heap profiler. 
It also includes three experimental tools: a heap/stack/global array overrun detector, 
a second heap profiler that examines how heap blocks are used, and a SimPoint basic 
block vector generator. It runs on the following platforms: X86/Linux, AMD64/Linux, 
ARM/Linux, PPC32/Linux, PPC64/Linux, S390X/Linux, ARM/Android (2.3.x), X86/Darwin 
and AMD64/Darwin (Mac OS X 10.6 and 10.7)."

pkg_vers_dft="3.7.0"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.bz2"
     pkg_urls="http://www.valgrind.org/downloads/$pkg_file"

     bldr_register_pkg                 \
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
