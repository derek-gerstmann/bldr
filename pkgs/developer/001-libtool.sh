#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="libtool"

pkg_default="2.4.2"
pkg_variants=("2.4.2")

pkg_info="GNU libtool is a generic library support script."

pkg_desc="GNU libtool is a generic library support script. 

Libtool hides the complexity of using shared libraries behind a consistent, portable interface. 

To use libtool, add the new generic library building commands to your Makefile, Makefile.in, 
or Makefile.am. See the documentation for details."

pkg_opts="configure force-static"
pkg_uses="m4 autoconf automake"
pkg_reqs="$pkg_uses"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftpmirror.gnu.org/libtool/$pkg_file"

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

