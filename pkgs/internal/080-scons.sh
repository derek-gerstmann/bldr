#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="scons"
pkg_vers="2.2.0"

pkg_info="SCons is an Open Source software construction tool—that is, a next-generation build tool."

pkg_desc="SCons is an Open Source software construction tool—that is, a next-generation build tool. 

Think of SCons as an improved, cross-platform substitute for the classic Make utility with 
integrated functionality similar to autoconf/automake and compiler caches such as ccache.

In short, SCons is an easier, more reliable and faster way to build software."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://downloads.sourceforge.net/project/scons/$pkg_name/$pkg_vers/$pkg_file"
pkg_opts="python"
pkg_uses=""
pkg_uses="$pkg_uses coreutils/latest"
pkg_uses="$pkg_uses findutils/latest"
pkg_uses="$pkg_uses diffutils/latest"
pkg_uses="$pkg_uses patch/latest"
pkg_uses="$pkg_uses sed/latest"
pkg_uses="$pkg_uses grep/latest"
pkg_uses="$pkg_uses tar/latest"
pkg_uses="$pkg_uses m4/latest"
pkg_uses="$pkg_uses autoconf/latest"
pkg_uses="$pkg_uses automake/latest"
pkg_uses="$pkg_uses pkg-config/latest"
pkg_uses="$pkg_uses make/latest"
pkg_uses="$pkg_uses python/2.7.3"
pkg_reqs="$pkg_uses"
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


