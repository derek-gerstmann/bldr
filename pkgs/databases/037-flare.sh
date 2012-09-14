#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="flare"
pkg_vers="1.0.15"

pkg_info="Flare is a distributed, and persistent key-value storage."

pkg_desc="Flare is a distributed, and persistent key-value storage."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="git://github.com/gree/flare.git"
pkg_opts="configure force-bootstrap"
pkg_uses="zlib/latest"
pkg_uses="$pkg_uses tokyo-cabinet/latest"
pkg_uses="$pkg_uses boost/latest"
pkg_uses="$pkg_uses openssl/latest"
pkg_reqs="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg="$pkg_cfg --with-tokyocabinet=$BLDR_TOKYO_CABINET_BASE_PATH"
pkg_cfg="$pkg_cfg --with-boost=$BLDR_BOOST_BASE_PATH"

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_cflags="$pkg_cflags -fPIC"
fi

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

