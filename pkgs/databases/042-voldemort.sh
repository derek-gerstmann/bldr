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
pkg_name="voldemort"
pkg_info="Voldemort is an open source distributed key-value database based on the design of Amazon's Dynamo."

pkg_desc="Voldemort is an open source distributed key-value database based on the design of Amazon's Dynamo.

It is used at LinkedIn for certain high-scalability storage problems where simple functional 
partitioning is not sufficient. It is still a new system which has rough edges, bad error 
messages, and probably plenty of uncaught bugs. Let us know if you find one of these, so we 
can fix it."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="https://github.com/downloads/voldemort/voldemort/$pkg_file"
pkg_opts="configure skip-config skip-build migrate-build-tree"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""

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
               --config      "$pkg_cfg"     


