#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="mongo-db"

pkg_default="2.2.1"
pkg_variants=("2.2.1")

pkg_info="MongoDB is a scalable, high-performance, open source NoSQL database. "

pkg_desc="MongoDB is a scalable, high-performance, open source NoSQL database. "

pkg_opts="configure skip-config skip-build skip-install migrate-build-tree"

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
     if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
         if [[ $BLDR_SYSTEM_IS_64BIT == true ]]; then
             pkg_file="mongodb-linux-x86_64-$pkg_vers.tgz"
         else
             pkg_file="mongodb-linux-i686-$pkg_vers.tgz"
         fi
         pkg_urls="http://fastdl.mongodb.org/linux/$pkg_file"
     fi
     if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
         pkg_file="mongodb-osx-x86_64-$pkg_vers.tgz"
         pkg_urls="http://fastdl.mongodb.org/osx/$pkg_file"
     fi

     if [[ "$pkg_urls" != "" ]]; then
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
     fi
done

####################################################################################################


