#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="vtf"

pkg_info="The Vampire Trace Format contains tools for trace date conversion or preparation."

pkg_desc="The Vampire Trace Format contains tools for trace date conversion or preparation."

pkg_vers_dft="1.43"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure skip-config skip-boot skip-compile skip-install migrate-build-headers migrate-build-bin"

####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_opts="$pkg_opts use-build-tree=apple"

elif [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     if [[ $BLDR_SYSTEM_IS_64BIT == true ]]
     then
          pkg_opts="$pkg_opts use-build-tree=x86_64"
     else
          pkg_opts="$pkg_opts use-build-tree=i386_linux"
     fi
fi

####################################################################################################

pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="${pkg_name}3-$pkg_vers.tar.gz"
     pkg_urls="http://www.cs.uoregon.edu/research/paracomp/tau/$pkg_file"

     bldr_register_pkg                 \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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
