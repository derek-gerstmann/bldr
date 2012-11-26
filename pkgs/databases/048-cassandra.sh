#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="cassandra"

pkg_default="1.1.6"
pkg_variants=("1.1.6")

pkg_info="The Apache Cassandra database is the right choice when you need scalability and high availability without compromising performance."

pkg_desc="The Apache Cassandra database is the right choice when you need scalability and high 
availability without compromising performance. Linear scalability and proven fault-tolerance on 
commodity hardware or cloud infrastructure make it the perfect platform for mission-critical data. 
Cassandra's support for replicating across multiple datacenters is best-in-class, providing lower 
latency for your users and the peace of mind of knowing that you can survive regional outages.

Cassandra's ColumnFamily data model offers the convenience of column indexes with the performance 
of log-structured updates, strong support for materialized views, and powerful built-in caching."

cas_opts="ant migrate-build-tree"

pkg_reqs="ant"
pkg_uses="ant"

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
     pkg_urls="git://github.com/apache/cassandra.git"
     
     pkg_opts="$cas_opts "
     pkg_opts+="checkout-branch=cassandra-$pkg_vers"

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

