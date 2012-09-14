#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="automake"
pkg_vers="1.12.2"
pkg_vers_list=("1.11" "$pkg_vers")
pkg_info="Automake is a Makefile generator."

pkg_desc="Automake is a Makefile generator.  It was inspired by the 4.4BSD 
make and include files, but aims to be portable and to conform to the 
GNU Coding Standards for Makefile variables and targets."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/automake/$pkg_file"
pkg_opts="configure force-static"
pkg_reqs="coreutils/latest m4/latest autoconf/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for am_vers in ${pkg_vers_list[@]}
do
     pkg_vers="$am_vers"
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftp.gnu.org/gnu/automake/$pkg_file"
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
done

