#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="spatial"
pkg_name="arboretum"

pkg_default="2.0.0"
pkg_variants=("2.0.0")

pkg_info="The GBDI Arboretum is a portable C++ library which implements various metric access methods (MAM)."

pkg_desc="The GBDI Arboretum is a portable C++ library which implements various metric access
methods (MAM). By using this library, any application will be able to perform similarity queries 
(queries by contents) with the minimum efforts possible. Furthermore, it will provide a robust 
and uniform platform for MAM developers which allows fair comparisons among all methods 
implemented by this library."

pkg_opts="configure skip-config skip-compile skip-install migrate-build-tree"
pkg_uses=""
pkg_reqs=""
pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="arboretum-1.0R2.tar.gz"
     pkg_urls="http://www.gbdi.icmc.usp.br/?q=system/files/arboretum-1.0R2.tar_.gz"

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
