#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="mxml"

pkg_default="2.7"
pkg_variants=("2.7")

pkg_info="Mini-XML is a small XML library that you can use to read and write XML and XML-like data files in your application without requiring large non-standard libraries."

pkg_desc="Mini-XML is a small XML library that you can use to read and write XML and XML-like 
data files in your application without requiring large non-standard libraries. Mini-XML only 
requires an ANSI C compatible compiler (GCC works, as do most vendors' ANSI C compilers) and 
a 'make' program.

Mini-XML supports reading of UTF-8 and UTF-16 and writing of UTF-8 encoded XML files and 
strings. Data is stored in a linked-list tree structure, preserving the XML data hierarchy, 
and arbitrary element names, attributes, and attribute values are supported with no preset 
limits, just available memory."

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftp.easysw.com/pub/$pkg_name/$pkg_vers/$pkg_file"

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
