#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="network"
pkg_name="openssl"

pkg_default="1.0.1c"
pkg_variants=("1.0.1c")

pkg_info="OpenSSL provides a Secure-Sockets Layer implementation (SSL v2/v3) and supports Transport Layer Security (TLS v1)."

pkg_desc="The OpenSSL Project is a collaborative effort to develop a robust, 
commercial-grade, full-featured, and Open Source toolkit implementing the 
Secure Sockets Layer (SSL v2/v3) and Transport Layer Security (TLS v1) protocols 
as well as a full-strength general purpose cryptography library managed by a 
worldwide community of volunteers that use the Internet to communicate, plan, 
and develop the OpenSSL toolkit and its related documentation."

pkg_opts="configure enable-static enable-shared skip-xcode-config force-serial-build"
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_cfg="-L$BLDR_LOCAL_PATH/compression/zlib/default/lib "
     pkg_cfg+="--openssldir=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/ssl "
     pkg_cfg+="zlib shared "

     if [ $BLDR_SYSTEM_IS_OSX == true ]
     then
          pkg_cfg+="no-asm no-krb5"
          pkg_cfg+="darwin64-x86_64-cc"
     fi

     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://www.openssl.org/source/$pkg_file"

     bldr_register_pkg                 \
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

