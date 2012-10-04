#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="fontconfig"

pkg_info="FontConfig is a library for configuring and customizing font access. "

pkg_desc="Fontconfig is a library designed to provide system-wide font configuration, 
customization and application access. 

Fontconfig contains two essential modules, the configuration module which builds an 
internal configuration from XML files and the matching module which accepts font 
patterns and returns the nearest matching font."

pkg_vers_dft="2.10.1"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure"
pkg_cfg="--disable-docs"
pkg_reqs="zlib libicu libiconv libxml2 freetype"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     if [[ $BLDR_SYSTEM_IS_64BIT == true ]]
     then
          pkg_cfg="$pkg_cfg --with-arch=x86_64"
     fi
     pkg_cfg="$pkg_cfg --with-sysroot=$BLDR_OSX_SYSROOT"
fi

pkg_uses=$pkg_reqs

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.freedesktop.org/software/$pkg_name/release/$pkg_file"

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
