#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="autoconf"
pkg_vers="2.68"

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
pkg_reqs="m4/latest"
pkg_opts="configure:keep"
pkg_cflags=0
pkg_ldflags=0
pkg_cfg="--disable-shared --enable-static"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg "$pkg_name"    \
               "$pkg_vers"    \
               "$pkg_info"    \
               "$pkg_desc"    \
               "$pkg_file"    \
               "$pkg_urls"    \
               "$pkg_reqs"    \
               "$pkg_opts"    \
               "$pkg_cflags"  \
               "$pkg_ldflags" \
               "$pkg_cfg"

