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

pkg_info="PyParsing is a general parsing module for Python."

pkg_desc="PyParsing is a general parsing module for Python.

Grammars are implemented directly in the client code using parsing objects, instead of externally, 
as with lex/yacc-type tools. 

Includes simple examples for parsing SQL, CORBA IDL, and 4-function math"

pkg_vers_dft="1.5.6"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="python skip-install"
pkg_reqs="python"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://downloads.sourceforge.net/project/$pkg_name/$pkg_name/$pkg_name-$pkg_vers/$pkg_file"

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

