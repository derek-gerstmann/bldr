#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="libxslt"
pkg_vers="1.1.26"
pkg_info="Libxslt is the XSLT C library developed for the GNOME project."

pkg_desc="Libxslt is the XSLT C library developed for the GNOME project. 
XSLT itself is a an XML language to define transformation for XML. Libxslt 
is based on libxml2 the XML C library developed for the GNOME project. It also 
implements most of the EXSLT set of processor-portable extensions functions and 
some of Saxon's evaluate and expressions extensions.

People can either embed the library in their application or use xsltproc the 
command line processing tool. This library is free software and can be reused 
in commercial applications (see the docs)."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://xmlsoft.org/sources/$pkg_file"
pkg_opts="configure"
pkg_reqs="libxml2/latest"
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


