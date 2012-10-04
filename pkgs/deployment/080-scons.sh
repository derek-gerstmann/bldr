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

pkg_info="SCons is an Open Source software construction tool—that is, a next-generation build tool."

pkg_desc="SCons is an Open Source software construction tool—that is, a next-generation build tool. 

Think of SCons as an improved, cross-platform substitute for the classic Make utility with 
integrated functionality similar to autoconf/automake and compiler caches such as ccache.

In short, SCons is an easier, more reliable and faster way to build software."

pkg_vers_dft="2.2.0"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="python skip-compile skip-install" 

pkg_uses=""
pkg_uses="$pkg_uses coreutils"
pkg_uses="$pkg_uses findutils"
pkg_uses="$pkg_uses diffutils"
pkg_uses="$pkg_uses patch"
pkg_uses="$pkg_uses sed"
pkg_uses="$pkg_uses grep"
pkg_uses="$pkg_uses tar"
pkg_uses="$pkg_uses m4"
pkg_uses="$pkg_uses autoconf"
pkg_uses="$pkg_uses automake"
pkg_uses="$pkg_uses pkg-config"
pkg_uses="$pkg_uses make"
pkg_uses="$pkg_uses python"
pkg_reqs="$pkg_uses"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://downloads.sourceforge.net/project/scons/$pkg_name/$pkg_vers/$pkg_file"

     bldr_register_pkg                \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_vers_dft"\
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

