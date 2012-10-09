#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="rexster"

pkg_default="2.1.0"
pkg_variants=(
     "2.1.0" "trunk")

pkg_mirrors=(
     "http://github.com/tinkerpop/$pkg_name/tarball/2.1.0"
     "git://github.com/tinkerpop/rexster.git")

pkg_distribs=(
     "$pkg_name-2.1.0.tar.gz"
     "$pkg_name-trunk-$BLDR_TIMESTAMP.tar.gz")

pkg_info="Rexster is a multi-faceted graph server that exposes any Blueprints graph through several mechanisms with a general focus on REST. "

pkg_desc="Rexster is a multi-faceted graph server that exposes any Blueprints graph 
through several mechanisms with a general focus on REST. 

Extensions support standard traversal goals such as search, score, rank, and, in 
concert, recommendation. Rexster makes extensive use of Blueprints, Pipes, and 
Gremlin. In this way its possible to run Rexster over various graph systems 
including:

* TinkerGraph in-memory graph
* Neo4j graph database
* OrientDB graph database
* DEX graph database
* Titan graph database
* Sesame 2.0 compliant RDF stores

Rexster provides a browser-based user interface known as The Dog House. 

This interface allows for viewing vertices, edges, and their related properties. 
A web-based console for executing Gremlin scripts is provided along with a Rexster 
Console which allows remote evaluation of scripts within the Rexster Server context."

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
