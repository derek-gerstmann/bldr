#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="hyperdex"

pkg_default="0.4.0"
pkg_variants=("0.4.0")

pkg_info="HyperDex is a searchable distributed Key-Value store."

pkg_desc="HyperDex is a searchable distributed Key-Value store.

HyperDex strategically places objects on servers so that both search and key-based 
operations contact a small subset of all servers in the system. Whereas typical key-value 
stores map objects to nodes using just the key, HyperDex takes into account all attributes 
of an object when mapping it to servers."

pkg_opts="configure enable-static enable-shared"
pkg_cfg="--enable-python-bindings"

pkg_reqs="pkg-config "
pkg_reqs+="zlib "
pkg_reqs+="cityhash "
pkg_reqs+="glog "
pkg_reqs+="libpopt "
pkg_reqs+="libpo6 "
pkg_reqs+="libe "
pkg_reqs+="busybee "
pkg_reqs+="python "
pkg_reqs+="cython "
pkg_reqs+="pyparsing "
pkg_uses="$pkg_reqs"

pkg_cflags="-lm"
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     bldr_log_warning "'$pkg_name/$pkg_vers' is not supported on OSX yet.  Skipping ..."
else
     for pkg_vers in ${pkg_variants[@]}
     do
          pkg_file="$pkg_name-$pkg_vers.tar.gz"
          pkg_urls="http://hyperdex.org/src/$pkg_file"
          
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
fi

####################################################################################################
