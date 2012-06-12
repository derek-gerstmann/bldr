#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="tcl"
pkg_vers="8.5.11"

pkg_info="Tool Command Language (Tcl) is an interpreted language and very portable interpreter for that language. "

pkg_desc="Tool Command Language (Tcl) is an interpreted language and very portable interpreter for that language. 

Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, 
suitable for a very wide range of uses, including web and desktop applications, networking, 
administration, testing and many more. Open source and business-friendly, Tcl is a mature yet 
evolving language that is truly cross platform, easily deployed and highly extensible."

pkg_file="tcl$pkg_vers-src.tar.gz"
pkg_urls="http://prdownloads.sourceforge.net/tcl/$pkg_file"
pkg_opts="configure"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "system"       \
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
               --config-path "unix"


