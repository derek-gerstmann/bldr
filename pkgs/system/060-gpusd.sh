#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="system"
pkg_name="gpusd"
pkg_vers="1.4"

pkg_info="Local and remote ZeroConf service discovery for GPU resources."

pkg_desc="Local and remote ZeroConf service discovery for GPU resources."

pkg_file="$pkg_name-$pkg_vers.zip"
pkg_urls="https://github.com/Eyescale/gpusd/zipball/1.4/$pkg_file"
pkg_opts="cmake"
pkg_uses=""
pkg_reqs=""
if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
     pkg_uses="avahi/latest"
fi
pkg_reqs="$pkg_uses"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

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

