#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="libxml2"
pkg_vers="2.8.0"
pkg_info="Libxml2 is the XML C parser and toolkit developed for the Gnome project"

pkg_desc="Libxml2 is the XML C parser and toolkit developed for the Gnome project 
(but usable outside of the Gnome platform), it is free software available under 
the MIT License. XML itself is a metalanguage to design markup languages, i.e. text 
language where semantic and structure are added to the content using extra 'markup' 
information enclosed between angle brackets. HTML is the most well-known markup 
language. Though the library is written in C a variety of language bindings make 
it available in other environments."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://xmlsoft.org/sources/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest"
pkg_uses="$pkg_reqs"
pkg_cfg=""
pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "internal"     \
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


