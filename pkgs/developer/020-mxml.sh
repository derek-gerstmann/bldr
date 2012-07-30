#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="mxml"
pkg_vers="2.7"
pkg_info="Mini-XML is a small XML library that you can use to read and write XML and XML-like data files in your application without requiring large non-standard libraries."

pkg_desc="Mini-XML is a small XML library that you can use to read and write XML and XML-like 
data files in your application without requiring large non-standard libraries. Mini-XML only 
requires an ANSI C compatible compiler (GCC works, as do most vendors' ANSI C compilers) and 
a 'make' program.

Mini-XML supports reading of UTF-8 and UTF-16 and writing of UTF-8 encoded XML files and 
strings. Data is stored in a linked-list tree structure, preserving the XML data hierarchy, 
and arbitrary element names, attributes, and attribute values are supported with no preset 
limits, just available memory."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.easysw.com/pub/$pkg_name/$pkg_vers/$pkg_file"
pkg_opts="configure"
pkg_reqs=""
pkg_uses="tar/latest m4/latest autoconf/latest automake/latest $pkg_reqs"

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


