#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="expat"

pkg_info="Expat is an XML parser library written in C."

pkg_desc="Expat is an XML parser library written in C. It is a stream-oriented parser 
in which an application registers handlers for things the parser might find in the 
XML document (like start tags). "

pkg_default="2.1.0"
pkg_variants=("$pkg_default")

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared" 

pkg_reqs="libtool "
pkg_reqs+="zlib "
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://prdownloads.sourceforge.net/$pkg_name/$pkg_vers/$pkg_file?download"

    bldr_register_pkg                \
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
