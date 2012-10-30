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

pkg_default="trunk"
pkg_variants=("trunk")

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

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
    pkg_urls="git://github.com/apavlo/h-store.git"
     
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

