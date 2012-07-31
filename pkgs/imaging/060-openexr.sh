#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="openexr"
pkg_vers="2.0-beta1"

pkg_info="OpenEXR is a high dynamic-range (HDR) image file format developed by Industrial Light & Magic for use in computer imaging applications."

pkg_desc="OpenEXR is a high dynamic-range (HDR) image file format developed by 
Industrial Light & Magic for use in computer imaging applications.

OpenEXR is used by ILM on all motion pictures currently in production. 
The first movies to employ OpenEXR were Harry Potter and the Sorcerers Stone, 
Men in Black II, Gangs of New York, and Signs. Since then, OpenEXR has become 
ILM's main image file format."

pkg_file="$pkg_name-$pkg_vers.zip"
pkg_urls="http://github.com/openexr/openexr/zipball/v2_beta.1"
pkg_opts="cmake skip-boot force-serial-build"
pkg_cfg_path="OpenEXR"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="internal/zlib imaging/lcms2 imaging/ilmbase"
for dep_pkg in $dep_list
do
     pkg_reqs="$pkg_reqs $dep_pkg/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/imaging/ilmbase/latest/include/OpenEXR"
pkg_cflags="$pkg_cflags:-I$BLDR_BUILD_PATH/imaging/$pkg_name/$pkg_vers/openexr/OpenEXR/IlmImf"

pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest $pkg_reqs"

pkg_cfg="--disable-dependency-tracking "
pkg_cfg="$pkg_cfg Z_CFLAGS=-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_cfg="$pkg_cfg Z_LIBS=-lz"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "imaging"      \
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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_path"


