#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="blueprints"
pkg_vers="2.1.0"

pkg_info="Blueprints is a property graph model interface."

pkg_desc="Blueprints is a property graph model interface. It provides implementations, 
test suites, and supporting extensions. Graph databases and frameworks that implement 
the Blueprints interfaces automatically support Blueprints-enabled applications. 

Likewise, Blueprints-enabled applications can plug-and-play different Blueprints-enabled 
graph backends."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://github.com/tinkerpop/$pkg_name/tarball/$pkg_vers"
pkg_opts="skip-config skip-compile skip-install migrate-build-tree"
pkg_uses="tar/latest"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_src"

####################################################################################################
# build and install pkg as local module
####################################################################################################

pkg_name="blueprints"
pkg_vers="trunk"
pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.bz2"
pkg_urls="git://github.com/tinkerpop/blueprints.git"
pkg_opts="maven skip-compile skip-install migrate-build-tree"
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
               --config-path "$pkg_cfg_src"

