#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="ilmbase"
pkg_vers="2.0-beta1"

pkg_info="IlmBase is a graphics and imaging framework developed at Industrial Light & Magic (primarily used by OpenEXR)"

pkg_desc="IlmBase is a graphics and imaging framework developed at Industrial Light & Magic.  
It is distributed as part of OpenEXR, but has become adopted for many other computer graphics 
related software packages, due to its stability, feature-set and overall code quality."

pkg_file="$pkg_name-$pkg_vers.zip"
pkg_urls="http://github.com/openexr/openexr/zipball/v2_beta.1"
pkg_opts="cmake skip-boot force-serial-build use-base-dir=openexr-openexr-d847d1e"
pkg_cfg_path="openexr-openexr-d847d1e/IlmBase"
pkg_reqs="zlib/latest lcms2/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

sub_list="Half IlmThread Imath ImathTest Iex IexMath IexTest"
for sub_inc in $sub_list
do
     pkg_cflags="$pkg_cflags:-I$BLDR_BUILD_PATH/imaging/$pkg_name/$pkg_vers/openexr/IlmBase/$sub_inc"
done

pkg_cfg="--disable-dependency-tracking "
pkg_cfg="$pkg_cfg Z_CFLAGS=-I\"$BLDR_ZLIB_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg Z_LIBS=-lz"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "$pkg_ctry"    \
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


