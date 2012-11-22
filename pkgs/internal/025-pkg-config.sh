#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="pkg-config"

pkg_default="0.23"
pkg_variants=("0.23")

pkg_info="Package Config is a helper tool used when compiling applications and libraries. "

pkg_desc="pkg-config is a helper tool used when compiling applications and libraries. 
It helps you insert the correct compiler options on the command line so an application 
can use  gcc -o test test.c \`pkg-config --libs --cflags glib-2.0\`  for instance, rather 
than hard-coding values on where to find glib (or other libraries). It is 
language-agnostic, so it can be used for defining the location of documentation 
tools, for instance."

pc_opts="configure force-static "

pkg_reqs=""
pkg_uses="coreutils"

pkg_cfg="--disable-maintainer-mode --disable-dependency-tracking --disable-dtrace" 

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://pkgconfig.freedesktop.org/releases/$pkg_file"
     
     pkg_opts="$pc_opts "
     pkg_opts+="-EPKG_CONFIG=$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bin/pkg-config "
     pkg_opts+="-EPKG_CONFIG_PATH=$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib/pkgconfig "
     
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
