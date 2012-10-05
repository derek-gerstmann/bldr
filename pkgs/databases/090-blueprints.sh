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

pkg_default="2.1.0"

pkg_variants=(
     "2.1.0" "trunk")

pkg_mirrors=(
     "http://github.com/tinkerpop/blueprints/tarball/2.1.0"
     "git://github.com/tinkerpop/blueprints.git")

pkg_distribs=(
     "blueprints-2.1.0.tar.gz")
     "blueprints-trunk-$BLDR_TIMESTAMP.tar.gz")

pkg_info="Blueprints is a property graph model interface."

pkg_desc="Blueprints is a property graph model interface. It provides implementations, 
test suites, and supporting extensions. Graph databases and frameworks that implement 
the Blueprints interfaces automatically support Blueprints-enabled applications. 

Likewise, Blueprints-enabled applications can plug-and-play different Blueprints-enabled 
graph backends."

pkg_opts="skip-config skip-compile skip-install migrate-build-tree"
pkg_uses="tar"
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_file=${pkg_distribs[$pkg_idx]}
     pkg_urls=${pkg_mirrors[$pkg_idx]}

     if [[ $pkg_vers == "trunk" ]]; then
          pkg_opts="maven skip-compile skip-install migrate-build-tree"
     fi

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

     let pkg_idx++
done

####################################################################################################
