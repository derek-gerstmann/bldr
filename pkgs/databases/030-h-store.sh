#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="h-store"

pkg_default="2012-06"
pkg_variants=("2012-06")
pkg_mirrors=("https://github.com/apavlo/h-store/tarball/release-2012-06")

pkg_info="H-Store is a Parallel Main Memory OLTP Database System."

pkg_desc="H-Store is a Parallel Main Memory OLTP Database System."

pkg_opts="ant migrate-build-tree"

pkg_uses="ant python "
if [[ $BLDR_SYSTEM_IS_OSX == false ]]; then
    pkg_uses+="valgrind "
fi

pkg_reqs="$pkg_uses"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="${pkg_mirrors[$pkg_idx]}"
     
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

