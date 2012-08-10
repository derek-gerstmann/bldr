#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ver_list=("5.2.1")
pkg_ctry="languages"
pkg_name="lua"

pkg_info="Lua is a powerful, fast, lightweight, embeddable scripting language."

pkg_desc="Lua is a powerful, fast, lightweight, embeddable scripting language.

Lua combines simple procedural syntax with powerful data description constructs based 
on associative arrays and extensible semantics. Lua is dynamically typed, runs by 
interpreting bytecode for a register-based virtual machine, and has automatic memory 
management with incremental garbage collection, making it ideal for configuration, 
scripting, and rapid prototyping."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.lua.org/ftp/$pkg_file"
pkg_opts="configure skip-install migrate-build-headers migrate-build-binaries migrate-build-libraries"
pkg_reqs="flex/latest bison/latest zlib/latest bzip2/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/compression/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/compression/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/bzip2/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/bzip2/latest/lib"

pkg_cfg=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_ver_list}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.lua.org/ftp/$pkg_file"

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
                   --cflags      "$pkg_cflags"  \
                   --ldflags     "$pkg_ldflags" \
                   --config      "$pkg_cfg"
done
