#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="deployment"
pkg_name="ant"

pkg_default="1.8.4"
pkg_variants=("1.8.4")

pkg_info="Apache Ant is a Java library and command-line tool that help building software."

pkg_desc="Apache Ant is a Java library and command-line tool that help building software."

pkg_opts="configure skip-config skip-build skip-install migrate-build-tree"
pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="apache-ant-$pkg_vers-bin.tar.bz2"
     pkg_urls="http://mirror.overthewire.com.au/pub/apache/ant/binaries/$pkg_file"

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

