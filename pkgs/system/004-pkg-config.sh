#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="pkg-config"
pkg_vers="0.24"

pkg_info="Package Config is a helper tool used when compiling applications and libraries. "

pkg_desc="pkg-config is a helper tool used when compiling applications and libraries. 
It helps you insert the correct compiler options on the command line so an application 
can use  gcc -o test test.c `pkg-config --libs --cflags glib-2.0`  for instance, rather 
than hard-coding values on where to find glib (or other libraries). It is 
language-agnostic, so it can be used for defining the location of documentation 
tools, for instance."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://pkgconfig.freedesktop.org/releases/$pkg_file"
pkg_reqs="m4/latest autoconf/latest automake/latest"
pkg_opts="configure:keep"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--disable-shared --enable-static"

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
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

####################################################################################################
# add subdirs to support our own version of PKGCFG for local package installs
####################################################################################################

if [ ! -d "$BLDR_LOCAL_DIR/$pkg_name/$pkg_vers/lib/pkgconfig" ]
then
    bldr_make_dir "$BLDR_LOCAL_DIR/$pkg_name/$pkg_vers/lib/pkgconfig"
    bldr_output_hline
fi
