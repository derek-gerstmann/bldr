#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="neo4j"

pkg_default="1.8"
pkg_variants=("1.8")

pkg_info="Neo4j is a high-performance, NOSQL graph database with all the features of a mature and robust database."

pkg_desc="Neo4j is a high-performance, NOSQL graph database with all the features 
of a mature and robust database. 

The programmer works with an object-oriented, flexible network structure rather than 
with strict and static tables — yet enjoys all the benefits of a fully transactional, 
enterprise-strength database. For many applications, Neo4j offers performance improvements 
on the order of 1000x or more compared to relational DBs.

Neo4j is an open source project available in a GPLv3 Community edition, with Advanced 
and Enterprise editions available under both the AGPLv3 and commercial licenses, 
supported by Neo Technology. Learn which license is right for you."

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

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-community-$pkg_vers-unix.tar.gz"
     pkg_urls="http://dist.neo4j.org/$pkg_file"

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

