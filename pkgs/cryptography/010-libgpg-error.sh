#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="cryptography"
pkg_name="libgpg-error"
pkg_vers="1.10"
pkg_info="The libgpg-error package contains a library that defines common error values for all GnuPG components."

pkg_desc="The libgpg-error package contains a library that defines common error values for all GnuPG 
components. Among these are GPG, GPGSM, GPGME, GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, 
SmartCard Daemon and more. "

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="ftp://ftp.gnupg.org/gcrypt/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs="coreutils/latest"
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


