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

pkg_default="2.0.7"
pkg_variants=("2.0.7")

pkg_info="SWIG is an interface compiler that connects programs written in C and C++ with scripting languages such as Perl, Python, Ruby, and Tcl."

pkg_desc="SWIG is an interface compiler that connects programs written in C and C++ with 
scripting languages such as Perl, Python, Ruby, and Tcl. It works by taking the declarations 
found in C/C++ header files and using them to generate the wrapper code that scripting 
languages need to access the underlying C/C++ code. In addition, SWIG provides a variety 
of customization features that let you tailor the wrapping process to suit your application.

John Ousterhout (creator of Tcl) has written a paper that describes the benefits of 
scripting languages. SWIG makes it fairly easy to connect scripting languages with 
C/C++ code."

pkg_opts="configure"
pkg_reqs="pcre m4 automake autoconf"
pkg_uses="pcre"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://prdownloads.sourceforge.net/$pkg_name/$pkg_file"

     bldr_register_pkg                \
        --category    "$pkg_ctry"     \
        --name        "$pkg_name"     \
        --version     "$pkg_vers"     \
        --default     "$pkg_default"  \
        --info        "$pkg_info"     \
        --description "$pkg_desc"     \
        --file        "$pkg_file"     \
        --url         "$pkg_urls"     \
        --uses        "$pkg_uses"     \
        --requires    "$pkg_reqs"     \
        --options     "$pkg_opts"     \
        --cflags      "$pkg_cflags"   \
        --ldflags     "$pkg_ldflags"  \
        --config      "$pkg_cfg"      \
        --config-path "$pkg_cfg_path"
done

####################################################################################################
