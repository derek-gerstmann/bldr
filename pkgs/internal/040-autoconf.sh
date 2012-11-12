#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="autoconf"

pkg_default="2.69"
pkg_variants=("2.66" "2.68" "2.69")

pkg_info="Autoconf is an extensible system to automatically configure software source code packages. "

pkg_desc="Autoconf is an extensible package of M4 macros that produce shell 
scripts to automatically configure software source code packages.           
These scripts can adapt the packages to many kinds of UNIX-like 
systems without manual user intervention.  Autoconf creates a 
configuration script for a package from a template file that lists the 
operating system features that the package can use, in the form of M4 
macro calls."

pkg_opts="configure force-static"
pkg_reqs="coreutils m4 libtool"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftp.gnu.org/gnu/autoconf/$pkg_file"

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
