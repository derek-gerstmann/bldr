#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="freetype-gl"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="FreeTypeGL provides a basic typography interface to use Freetype fonts in OpenGL."

pkg_desc="FreeTypeGL provides a basic typography interface to use Freetype fonts in OpenGL."

pkg_opts="cmake migrate-build-headers migrate-build-source migrate-build-bin"
pkg_uses="freetype fontconfig atb"
if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
  pkg_uses="$pkg_uses freeglut"
fi
pkg_reqs="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg_path="build"
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
    pkg_urls="svn://freetype-gl.googlecode.com/svn/trunk"

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

    let pkg_idx++
done

####################################################################################################


