#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="cogl"
pkg_vers="1.10.2"

pkg_info="Cogl is a modern 3D graphics API with associated utility APIs designed to expose the features of 3D graphics hardware using a direct state access API design, as opposed to the state-machine style of OpenGL."

pkg_desc="Cogl is a modern 3D graphics API with associated utility APIs designed to 
expose the features of 3D graphics hardware using a direct state access API design, 
as opposed to the state-machine style of OpenGL. It is implemented in the C programming 
language but we want to provide bindings for everyone's favorite language too."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://source.clutter-project.org/sources/cogl/1.10/$pkg_file"
pkg_opts="configure"
pkg_cfg=""
pkg_cfg_path=""

pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="compression/zlib text/libicu formats/libxml2"
dep_list="$dep_list text/gettext developer/glib"
dep_list="$dep_list imaging/libpng typography/pango"

if [[ $BLDR_SYSTEM_IS_OSX == false ]]; then
     dep_list="$dep_list text/libiconv"
fi

for dep_pkg in $dep_list
do
     pkg_req_name=$(echo "$dep_pkg" | sed 's/.*\///g' )
     pkg_reqs="$pkg_reqs $pkg_req_name/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cflags="$pkg_cflags:-I/usr/local/include:-I/usr/include"
     pkg_ldflags="$pkg_ldflags:-L/usr/local/lib:-L/usr/lib:-lintl"
fi

pkg_uses="$pkg_reqs"

####################################################################################################
# build and install pkg as local module
####################################################################################################

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

