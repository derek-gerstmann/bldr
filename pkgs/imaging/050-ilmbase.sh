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

pkg_default="2.0-beta1"
pkg_variants=("2.0-beta1" "trunk")
pkg_mirrors=(
    "http://github.com/openexr/openexr/zipball/v2_beta.1"
    "git://github.com/openexr/openexr.git")
pkg_bases=(
    "openexr-openexr-93484b1"
    "openexr-trunk")

pkg_info="IlmBase is a graphics and imaging framework developed at Industrial Light & Magic (primarily used by OpenEXR)"

pkg_desc="IlmBase is a graphics and imaging framework developed at Industrial Light & Magic.  
It is distributed as part of OpenEXR, but has become adopted for many other computer graphics 
related software packages, due to its stability, feature-set and overall code quality."

pkg_reqs="zlib lcms2"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

ilm_cflags=""
ilm_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     ilm_cflags+="-fPIC "
     ilm_cflags+="-DHAVE_PTHREAD "
     ilm_cflags+="-DHAVE_POSIX_SEMAPHORES "
fi
if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     ilm_cflags+="-DHAVE_PTHREAD "
fi

pkg_cfg="--disable-dependency-tracking "
pkg_cfg+="Z_CFLAGS=-I\"$BLDR_ZLIB_INCLUDE_PATH\" "
pkg_cfg+="Z_LIBS=-lz "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.zip"
    pkg_base=${pkg_bases[$pkg_idx]}
    pkg_urls=${pkg_mirrors[$pkg_idx]}

    pkg_ldflags="$ilm_ldflags"
    pkg_cflags="$ilm_cflags"
    pkg_subs=("Half" "IlmThread" "Imath" "ImathTest" "Iex" "IexMath" "IexTest")
    for sub_inc in ${pkg_subs[@]}
    do
         pkg_cflags+=":-I$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$pkg_base/IlmBase/$sub_inc "
    done

    pkg_opts="cmake skip-boot force-serial-build "

    if [[ "$pkg_base" != "trunk" ]]; then
        pkg_opts+="use-base-dir=$pkg_base "
        pkg_cfg_path="$pkg_base/IlmBase"
    else
        pkg_cfg_path="IlmBase"
    fi

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

    let pkg_idx++
done

####################################################################################################
