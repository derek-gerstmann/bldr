#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="languages"
pkg_name="lua"

pkg_default="5.2.1"
pkg_variants=("5.2.1")

pkg_info="Lua is a powerful, fast, lightweight, embeddable scripting language."

pkg_desc="Lua is a powerful, fast, lightweight, embeddable scripting language.

Lua combines simple procedural syntax with powerful data description constructs based 
on associative arrays and extensible semantics. Lua is dynamically typed, runs by 
interpreting bytecode for a register-based virtual machine, and has automatic memory 
management with incremental garbage collection, making it ideal for configuration, 
scripting, and rapid prototyping."

lua_opts="configure "
pkg_reqs="flex bison zlib bzip2"
pkg_uses="$pkg_reqs"

pkg_cfg=""
pkg_cfg_path=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    lua_opts+="-Mmacosx "
    
elif [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    lua_opts+="-Mlinux "
    pkg_cflags="$pkg_cflags:-fPIC"
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.lua.org/ftp/$pkg_file"
    pkg_opts="$lua_opts -MPREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_register_pkg                 \
        --category    "$pkg_ctry"    \
        --name        "$pkg_name"    \
        --version     "$pkg_vers"    \
        --default     "$pkg_default"\
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
