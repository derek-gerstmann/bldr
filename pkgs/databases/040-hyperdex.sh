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
pkg_vers="0.4.0"

pkg_info="HyperDex is a searchable distributed Key-Value store."
pkg_desc="HyperDex is a searchable distributed Key-Value store.

HyperDex strategically places objects on servers so that both search and key-based 
operations contact a small subset of all servers in the system. Whereas typical key-value 
stores map objects to nodes using just the key, HyperDex takes into account all attributes 
of an object when mapping it to servers."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://hyperdex.org/src/$pkg_file"
pkg_opts="configure"
pkg_reqs="pkg-config/latest"
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs cityhash/latest"
pkg_reqs="$pkg_reqs glog/latest"
pkg_reqs="$pkg_reqs libpopt/latest"
pkg_reqs="$pkg_reqs libpo6/latest"
pkg_reqs="$pkg_reqs libe/latest"
pkg_reqs="$pkg_reqs busybee/latest"
pkg_reqs="$pkg_reqs python/2.7.3"
pkg_reqs="$pkg_reqs cython/latest"
pkg_reqs="$pkg_reqs pyparsing/latest"
pkg_uses="$pkg_reqs"
pkg_cflags="-lm"
pkg_ldflags=""
pkg_cfg="--enable-python-bindings"
pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     bldr_log_warning "'$pkg_name/$pkg_vers' is not supported on OSX yet.  Skipping ..."
else
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
                    --patch       "$pkg_patch"   \
                    --cflags      "$pkg_cflags"  \
                    --ldflags     "$pkg_ldflags" \
                    --config      "$pkg_cfg"
fi
