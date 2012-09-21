#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="0.96"
pkg_ctry="databases"
pkg_name="voldemort-cpp"
pkg_info="The Voldemort CPP client provides a Thrift interface to Voldemort Server."

pkg_desc="The Voldemort CPP client provides a Thrift interface to Voldemort Server."

pkg_file="voldemort-$pkg_vers.tar.gz"
pkg_urls="https://github.com/downloads/voldemort/voldemort/$pkg_file"
pkg_opts="configure force-bootstrap"
pkg_opts="$pkg_opts use-build-tree=clients/cpp use-base-dir=clients/cpp"
pkg_reqs="voldemort/0.96 boost/latest protobuf/latest expat/latest"
pkg_uses=""

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
pkg_cfg="--with-boost=$BLDR_BOOST_BASE_PATH"
pkg_cfg_path="clients/cpp"

####################################################################################################
# build and install each pkg version as local module
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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_path"


