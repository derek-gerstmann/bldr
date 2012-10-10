#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="languages"
pkg_name="cython"

pkg_default="0.17.1"
pkg_variants=("0.17.1")

pkg_info="Cython is a language that makes writing C extensions for the Python language as easy as Python itself."

pkg_desc="Cython is a language that makes writing C extensions for the Python language as easy as Python itself. 

Cython is a programming language based on Python, with extra syntax allowing for optional static type declarations. 
It aims to become a superset of the [Python] language which gives it high-level, object-oriented, functional, 
and dynamic programming. The source code gets translated into optimized C/C++ code and compiled as Python 
extension modules. This allows for both very fast program execution and tight integration with external C 
libraries, while keeping up the high programmer productivity for which the Python language is well known."

pkg_opts="python skip-compile skip-install"
pkg_reqs="python"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_variants}
do
     pkg_file="Cython-$pkg_vers.tar.gz"
     pkg_urls="http://www.cython.org/release/$pkg_file"

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
