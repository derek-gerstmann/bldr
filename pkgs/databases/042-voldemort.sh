#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="voldemort"

pkg_default="0.96"
pkg_variants=("0.96")

pkg_info="Voldemort is an open source distributed key-value database based on the design of Amazon's Dynamo."

pkg_desc="Voldemort is an open source distributed key-value database based on the design of Amazon's Dynamo.

It is used at LinkedIn for certain high-scalability storage problems where simple functional 
partitioning is not sufficient. It is still a new system which has rough edges, bad error 
messages, and probably plenty of uncaught bugs. Let us know if you find one of these, so we 
can fix it."

pkg_opts="configure skip-config skip-build migrate-build-tree"
pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="https://github.com/downloads/voldemort/voldemort/$pkg_file"
     
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

