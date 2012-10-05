#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="languages"
pkg_name="tcl"

pkg_default="8.5.12"
pkg_variants=("8.5.12")

pkg_info="Tool Command Language (Tcl) is an interpreted language and very portable interpreter for that language. "

pkg_desc="Tool Command Language (Tcl) is an interpreted language and very portable interpreter for that language. 

Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, 
suitable for a very wide range of uses, including web and desktop applications, networking, 
administration, testing and many more. Open source and business-friendly, Tcl is a mature yet 
evolving language that is truly cross platform, easily deployed and highly extensible."

pkg_opts="configure migrate-build-tree force-serial-build"
pkg_uses="m4 autoconf automake"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_64BIT == true ]]; then
     pkg_cfg+="--enable-64bit "
fi

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cfg+="--disable-framework "
     pkg_cfg_path="unix"
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
     pkg_cfg_path="unix"
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="tcl$pkg_vers-src.tar.gz"
     pkg_urls="http://prdownloads.sourceforge.net/tcl/$pkg_file"

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

