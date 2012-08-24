#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="system"
pkg_name="avahi"
pkg_vers="0.6.31"

pkg_info="Avahi is a system which facilitates service discovery on a local network via the mDNS/DNS-SD protocol suite."

pkg_desc="Avahi is a system which facilitates service discovery on a local network via the 
mDNS/DNS-SD protocol suite. This enables you to plug your laptop or computer into a network 
and instantly be able to view other people who you can chat with, find printers to print 
to or find files being shared. Compatible technology is found in Apple MacOS X (branded  
Bonjour and sometimes Zeroconf)."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://avahi.org/download/$pkg_file"
pkg_opts="configure"
pkg_uses=""
pkg_reqs=""
pkg_uses="coreutils/latest tar/latest"
pkg_reqs="$pkg_uses"
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

