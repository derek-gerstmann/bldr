#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="libicu"
pkg_vers="49.1.2"
pkg_info="ICU is the premier library for software internationalization."

pkg_desc="ICU is the premier library for software internationalization.

ICU is a mature, widely used set of C/C++ and Java libraries providing Unicode and 
Globalization support for software applications. ICU is widely portable and gives 
applications the same results on all platforms and between C/C++ and Java software.
ICU is released under a nonrestrictive open source license that is suitable for use 
with both commercial software and with other open source or free software."

pkg_file="icu4c-49_1_2-src.tgz"
pkg_urls="http://download.icu-project.org/files/icu4c/49.1.2/$pkg_file"
pkg_opts="configure force-static"
pkg_reqs="zlib/latest"
pkg_uses="m4/latest autoconf/latest automake/latest $pkg_reqs"
pkg_cfg=""
pkg_cflags="-I$BLDR_LOCAL_DIR/system/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_DIR/system/zlib/latest/lib"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "system"       \
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


