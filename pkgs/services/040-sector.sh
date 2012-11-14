#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="services"
pkg_name="sector"

pkg_default="2.9"
pkg_variants=("2.9")

pkg_info="Sector is a high performance, scalable, and secure distributed file system."

pkg_desc="Sector is a high performance, scalable, and secure distributed file system.

Sector/Sphere supports distributed data storage, distribution, and processing over large 
clusters of commodity computers, either within a data center or across multiple data centers. 

Sector is a high performance, scalable, and secure distributed file system. Sphere is a high 
performance parallel data processing engine that can process Sector data files on the storage 
nodes with very simple programming interfaces. "

pkg_opts="configure force-serial-build skip-install migrate-build-tree migrate-build-bin migrate-build-headers"
pkg_reqs="openssl"
pkg_uses="$pkg_uses"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name.$pkg_vers.tar.gz"
    pkg_urls="http://aarnet.dl.sourceforge.net/project/sector/SECTOR/$pkg_vers/$pkg_file"
    bldr_register_pkg                 \
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

