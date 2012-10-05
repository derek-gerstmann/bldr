#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="glew"

pkg_default="1.9.0"
pkg_variants=("1.9.0")

pkg_info="The OpenGL Extension Wrangler Library (GLEW) is a cross-platform open-source C/C++ extension loading library."

pkg_desc="The OpenGL Extension Wrangler Library (GLEW) is a cross-platform open-source C/C++ 
extension loading library. GLEW provides efficient run-time mechanisms for determining which 
OpenGL extensions are supported on the target platform. OpenGL core and extension functionality 
is exposed in a single header file. GLEW has been tested on a variety of operating systems, 
including Windows, Linux, Mac OS X, FreeBSD, Irix, and Solaris. "

glew_opts="configure "
glew_opts+="skip-config "

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
  glew_opts+="-MSYSTEM=darwin "

elif [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
  glew_opts+="-MSYSTEM=linux "
fi

pkg_uses="perl"
pkg_reqs="$pkg_uses"

pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tgz"
    pkg_urls="http://sourceforge.net/projects/glew/files/$pkg_name/$pkg_vers/$pkg_file/download"
    pkg_opts="$glew_opts -MGLEW_DEST=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers\""

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
