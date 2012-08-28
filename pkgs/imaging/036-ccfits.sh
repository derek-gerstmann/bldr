#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="ccfits"
pkg_vers="2.4"

pkg_info="CCfits is an object oriented interface to the cfitsio library."

pkg_desc="CCfits is an object oriented interface to the cfitsio library. 
It is designed to make the capabilities of cfitsio available to programmers 
working in C++. It is written in ANSI C++ and implemented using the C++ 
Standard Library with namespaces, exception handling, and member template 
functions."

pkg_file="CCfits-$pkg_vers.tar.gz"
pkg_urls="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/ccfits/$pkg_file"
pkg_opts="configure force-serial-build"
pkg_reqs="zlib/latest cfitsio/latest"
pkg_uses="$pkg_reqs"
pkg_cflags="-I$BLDR_LOCAL_PATH/compression/zlib/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/imaging/cfitsio/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_BUILD_PATH/imaging/$pkg_name/$pkg_vers/include"
pkg_cflags="$pkg_cflags:-I$BLDR_BUILD_PATH/imaging/$pkg_name/$pkg_vers/include/CCfits"
pkg_ldflags="-L$BLDR_LOCAL_PATH/compression/zlib/latest/lib"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/imaging/cfitsio/latest/lib"
pkg_cfg="--with-cfitsio=$BLDR_LOCAL_PATH/imaging/cfitsio/latest"

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags="$pkg_cflags -fPIC"
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "imaging"      \
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


