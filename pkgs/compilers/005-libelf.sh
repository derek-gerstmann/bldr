#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="libelf"
pkg_vers="0.8.13"
pkg_info="LibELF lets you read, modify or create ELF files in an architecture-independent way."

pkg_desc="LibELF lets you read, modify or create ELF files in an architecture-independent way. 

The library takes care of size and endian issues, e.g. you can process a file for SPARC 
processors on an Intel-based system. This library is a clean-room rewrite of the 
System V Release 4 library and is supposed to be source code compatible with it. 

It was meant primarily for porting SVR4 applications to other operating systems but 
can also be used as the basis for new applications (and as a light-weight alternative 
to libbfd). "

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.mr511.de/software/$pkg_file"
pkg_opts="configure skip-xcode-config"
pkg_reqs=""
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


