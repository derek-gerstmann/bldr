#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="otf"
pkg_vers="1.11.2"
pkg_info="The Open Trace Format contains tools for trace date conversion or preparation."

pkg_desc="The Open Trace Format contains tools for trace date conversion or preparation."

pkg_file="OTF-1.11.2goldfish.tar.gz"
pkg_urls="http://tu-dresden.de/die_tu_dresden/zentrale_einrichtungen/zih/forschung/software_werkzeuge_zur_unterstuetzung_von_programmierung_und_optimierung/otf/dateien/$pkg_file"
pkg_opts="configure"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--enable-static --enable-shared"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                   \
    --category    "$pkg_ctry"    \
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

