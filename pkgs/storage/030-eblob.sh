#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="eblob"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="Eblob is an append-only low-level IO library, which saves data in blob files."

pkg_desc="Eblob is an append-only low-level IO library, which saves data in blob files."

pkg_opts="cmake"

pkg_reqs="zlib "
pkg_reqs+="python "
pkg_reqs+="snappy "
pkg_reqs+="boost "
pkg_uses="$pkg_reqs"

pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
    pkg_urls="git://github.com/reverbrain/eblob.git"

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
done

####################################################################################################
