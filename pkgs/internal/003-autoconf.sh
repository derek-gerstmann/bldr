#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="autoconf"
pkg_vers="2.69"

pkg_info="Autoconf is an extensible system to automatically configure software source code packages. "

pkg_desc="Autoconf is an extensible package of M4 macros that produce shell 
scripts to automatically configure software source code packages.           
These scripts can adapt the packages to many kinds of UNIX-like 
systems without manual user intervention.  Autoconf creates a 
configuration script for a package from a template file that lists the 
operating system features that the package can use, in the form of M4 
macro calls."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/autoconf/$pkg_file"
pkg_opts="configure force-static"
pkg_uses="m4/latest"
pkg_reqs="m4/latest"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "internal"     \
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


