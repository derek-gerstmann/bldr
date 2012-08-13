#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="make"
pkg_vers="3.82"

pkg_info="GNU Make is a tool which controls the generation of executables and other non-source files of a program from the program's source files."

pkg_desc="GNU Make is a tool which controls the generation of executables and other non-source 
files of a program from the program's source files.

Make gets its knowledge of how to build your program from a file called the makefile, which 
lists each of the non-source files and how to compute it from other files. When you write a 
program, you should write a makefile for it, so that it is possible to use Make to build and 
install the program."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/make/$pkg_file"
pkg_opts="configure force-static"
pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest"
pkg_reqs="$pkg_uses"
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


