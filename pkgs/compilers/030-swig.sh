#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="swig"
pkg_vers="2.0.7"
pkg_info="SWIG is an interface compiler that connects programs written in C and C++ with scripting languages such as Perl, Python, Ruby, and Tcl."

pkg_desc="SWIG is an interface compiler that connects programs written in C and C++ with 
scripting languages such as Perl, Python, Ruby, and Tcl. It works by taking the declarations 
found in C/C++ header files and using them to generate the wrapper code that scripting 
languages need to access the underlying C/C++ code. In addition, SWIG provides a variety 
of customization features that let you tailor the wrapping process to suit your application.

John Ousterhout (creator of Tcl) has written a paper that describes the benefits of 
scripting languages. SWIG makes it fairly easy to connect scripting languages with 
C/C++ code."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://prdownloads.sourceforge.net/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs="pcre/latest"
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags="$pkg_cflags -fPIC"
fi

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


