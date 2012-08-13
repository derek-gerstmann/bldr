#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="freetype-gl"
pkg_vers="trunk"

pkg_info="FreeTypeGL provides a basic typography interface to use Freetype fonts in OpenGL."

pkg_desc="FreeTypeGL provides a basic typography interface to use Freetype fonts in OpenGL."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="svn://freetype-gl.googlecode.com/svn/trunk"
pkg_opts="configure skip-install migrate-build-tree"
pkg_uses=""
pkg_reqs=""
pkg_cfg="--enable-shared --enable-static"
pkg_cflags=""
pkg_ldflags=""

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

