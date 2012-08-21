#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="pyparsing"
pkg_vers="1.5.6"
pkg_info="PyParsing is a general parsing module for Python."

pkg_desc="PyParsing is a general parsing module for Python.

Grammars are implemented directly in the client code using parsing objects, instead of externally, 
as with lex/yacc-type tools. 

Includes simple examples for parsing SQL, CORBA IDL, and 4-function math"

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://downloads.sourceforge.net/project/$pkg_name/$pkg_name/$pkg_name-$pkg_vers/$pkg_file"
pkg_opts="python"
pkg_reqs=""
pkg_uses=""
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


