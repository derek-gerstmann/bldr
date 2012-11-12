#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="smack"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="SMACK - low-level IO storage which packs data into sorted (zlib/bzip2/snappy compressed) blobs."

pkg_desc="SMACK - low-level IO storage which packs data into sorted (zlib/bzip2/snappy compressed) blobs."

pkg_opts="cmake"

pkg_reqs="zlib "
pkg_reqs+="snappy "
pkg_reqs+="bzip2 "
pkg_reqs+="python "
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
    pkg_urls="git://github.com/reverbrain/smack.git"

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
