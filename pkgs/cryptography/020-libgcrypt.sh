#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="cryptography"
pkg_name="libgcrypt"
pkg_vers="1.5.0"
pkg_info="The libgcrypt package contains a general purpose crypto library based on the code used in GnuPG."

pkg_desc="The libgcrypt package contains a general purpose crypto library based on the code used in GnuPG. 
The library provides a high level interface to cryptographic building blocks using an extendable 
and flexible API."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="ftp://ftp.gnupg.org/gcrypt/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs="coreutils/latest libgpg-error/latest"
pkg_uses=""
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


