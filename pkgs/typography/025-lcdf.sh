#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="lcdf"

pkg_info="The LCDF Typetools package offers tools for manipulating PostScript-flavored fonts."

pkg_desc="The LCDF Typetools package contains several command-line programs for 
manipulating PostScript Type 1 and PostScript-flavored OpenType fonts."

pkg_vers_dft="2.93"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure skip-auto-compile-flags"
pkg_uses="pkg-config/latest coreutils/latest"
pkg_reqs=""
pkg_cfg="--without-kpathsea"
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]] 
then
     pkg_cflags="$pkg_cflags -fPIC"    
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="lcdf-typetools-${pkg_vers}.tar.gz"
    pkg_urls="http://www.lcdf.org/type/$pkg_file"

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

