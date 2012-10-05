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

pkg_default="1.5.0"
pkg_variants=("1.5.0")

pkg_info="The libgcrypt package contains a general purpose crypto library based on the code used in GnuPG."

pkg_desc="The libgcrypt package contains a general purpose crypto library based on the code used in GnuPG. 
The library provides a high level interface to cryptographic building blocks using an extendable 
and flexible API."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="coreutils libgpg-error"
pkg_uses="bzip2 tar"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.bz2"
     pkg_urls="ftp://ftp.gnupg.org/gcrypt/$pkg_name/$pkg_file"

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


