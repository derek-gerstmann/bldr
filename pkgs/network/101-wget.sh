#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="network"
pkg_name="wget"

pkg_info="wget is a command line tool for retrieving files with URL syntax."

pkg_desc="wget is a command line tool for retrieving files using HTTP, HTTPS and FTP, 
the most widely-used Internet protocols. It is a non-interactive commandline tool, 
so it may easily be called from scripts, cron jobs, terminals without X-Windows support, etc."

pkg_vers_dft="1.13.4"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_reqs="openssl"
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--with-ssl=openssl --with-libssl-prefix=$BLDR_LOCAL_PATH/network/openssl/latest"

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftp.gnu.org/gnu/wget/$pkg_file"

     bldr_register_pkg                 \
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

