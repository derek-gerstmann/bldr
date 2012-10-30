#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="level-db"

pkg_default="1.5.0"
pkg_variants=("1.5.0")

pkg_info="LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values."

pkg_desc="LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.

Features
* Keys and values are arbitrary byte arrays.
* Data is stored sorted by key.
* Callers can provide a custom comparison function to override the sort order.
* The basic operations are Put(key,value), Get(key), Delete(key).
* Multiple changes can be made in one atomic batch.
* Users can create a transient snapshot to get a consistent view of data.
* Forward and backward iteration is supported over the data.
* Data is automatically compressed using the Snappy compression library.
* External activity (file system operations etc.) is relayed through a virtual interface so users can customize the operating system interactions.
* Detailed documentation about how to use the library is included with the source code.

Limitations
* This is not a SQL database. It does not have a relational data model, it does not support SQL queries, and it has no support for indexes.
* Only a single process (possibly multi-threaded) can access a particular database at a time.
* There is no client-server support builtin to the library. An application that needs such support will have to wrap their own server around the library."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "
pkg_opts+="migrate-build-headers "
pkg_opts+="migrate-build-bin "
pkg_opts+="migrate-build-doc "

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
     pkg_file="leveldb-$pkg_vers.tar.gz"
     pkg_urls="https://leveldb.googlecode.com/files/$pkg_file"

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


