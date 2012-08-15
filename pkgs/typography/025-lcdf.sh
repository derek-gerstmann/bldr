#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="lcdf"
pkg_vers="2.92"

pkg_info="The LCDF Typetools package offers tools for manipulating PostScript-flavored fonts."

pkg_desc="The LCDF Typetools package contains several command-line programs for 
manipulating PostScript Type 1 and PostScript-flavored OpenType fonts."

pkg_file="lcdf-typetools-2.92.tar.gz"
pkg_urls="http://www.lcdf.org/type/$pkg_file"
pkg_opts="configure keep"
pkg_uses=""
pkg_reqs=""
pkg_cfg="--without-kpathsea"
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                 \
  --category    "$pkg_ctry"    \
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


