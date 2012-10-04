#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="msgpack"
pkg_info="MessagePack is an efficient binary serialization format. "

pkg_desc="MessagePack is an efficient binary serialization format. 
It lets you exchange data among multiple languages like JSON but it's faster 
and smaller. For example, small integers (like flags or error code) are encoded 
into a single byte, and typical short strings only require an extra byte in 
addition to the strings themselves.

If you ever wished to use JSON for convenience (storing an image with metadata) 
but could not for technical reasons (encoding, size, speed...), MessagePack 
is a perfect replacement."

pkg_vers_dft="0.5.7"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure force-static"
pkg_reqs=""
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://msgpack.org/releases/cpp/$pkg_file"

     bldr_register_pkg                  \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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
