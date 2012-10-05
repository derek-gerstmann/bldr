#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="ccfits"

pkg_default="2.4"
pkg_variants=("2.4")

pkg_info="CCfits is an object oriented interface to the cfitsio library."

pkg_desc="CCfits is an object oriented interface to the cfitsio library. 
It is designed to make the capabilities of cfitsio available to programmers 
working in C++. It is written in ANSI C++ and implemented using the C++ 
Standard Library with namespaces, exception handling, and member template 
functions."

pkg_opts="configure enable-static enable-shared force-serial-build"
pkg_reqs="zlib cfitsio"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--with-cfitsio=$BLDR_CFITSIO_BASE_PATH"
ccf_cflags="-I$BLDR_ZLIB_INCLUDE_PATH"
ccf_cflags+=":-I$BLDR_CFITSIO_INCLUDE_PATH"

ccf_ldflags="-L$BLDR_ZLIB_LIB_PATH"
ccf_ldflags+=":-L$BLDR_CFITSIO_LIB_PATH"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="CCfits-$pkg_vers.tar.gz"
     pkg_urls="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/ccfits/$pkg_file"

     pkg_cflags="$ccf_cflags"
     pkg_cflags+=":-I$BLDR_BUILD_PATH/imaging/$pkg_name/$pkg_vers/include"
     pkg_cflags+=":-I$BLDR_BUILD_PATH/imaging/$pkg_name/$pkg_vers/include/CCfits"

     pkg_ldflags="$ccf_ldflags"

     bldr_register_pkg                \
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
