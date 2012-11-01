#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="padb"

pkg_default="3.3"
pkg_variants=("3.3")

pkg_info="Padb is a Job Inspection Tool for examining and debugging parallel programs."

pkg_desc="Padb is a Job Inspection Tool for examining and debugging parallel programs, primarily 
it simplifies the process of gathering stack traces on compute clusters however it also supports a 
wide range of other functions. Padb supports a number of parallel environments and it works 
out-of-the-box on the majority of clusters. It's an open source, non-interactive, command line, 
script-able tool intended for use by programmers and system administrators alike."

pkg_opts="configure"
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

####################################################################################################

pkg_reqs="openmpi "
pkg_uses="openmpi "

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://padb.googlecode.com/files/$pkg_file"

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
