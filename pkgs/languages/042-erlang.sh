#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="languages"
pkg_name="erlang"

pkg_info="Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability."

pkg_desc="Erlang is a programming language used to build massively scalable soft real-time 
systems with requirements on high availability. Some of its uses are in telecoms, banking, e-commerce, 
computer telephony and instant messaging.  Erlang's runtime system has built-in support for 
concurrency, distribution and fault tolerance."

pkg_default="R15B02"
pkg_variants=("$pkg_default")

pkg_opts="configure "
pkg_reqs="coreutils openssl "
pkg_uses="$pkg_reqs tar make "

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--enable-native-libs "
pkg_cfg+="--with-ssl=$BLDR_OPENSSL_BASE_PATH "
pkg_cfg+="--enable-threads "
pkg_cfg+="--enable-smp-support "
pkg_cfg+="--enable-sctp-support "
pkg_cfg+="--enable-kernel-poll "
if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_cfg+="--disable-hipe "
    if [[ $BLDR_SYSTEM_IS_64BIT == true ]]; then
        pkg_cfg+="--enable-darwin-64bit "
    else
        pkg_cfg+="--enable-darwin-universal "
    fi
else
    pkg_cfg+="--enable-hipe "
    if [[ $BLDR_SYSTEM_IS_64BIT == true ]]; then
        pkg_cfg+="--enable-m64-build "
    else
        pkg_cfg+="--enable-m32-build "
    fi
fi

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_variants}
do
    pkg_file="otp_src_$pkg_vers.tar.gz"
    pkg_urls="http://www.erlang.org/download/$pkg_file"

    bldr_register_pkg                  \
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
