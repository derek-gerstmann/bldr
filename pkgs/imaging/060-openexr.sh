#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="openexr"

pkg_default="trunk"
pkg_variants=("trunk" "2.0-beta1")
pkg_mirrors=(
    "git://github.com/openexr/openexr.git"
    "http://github.com/openexr/openexr/zipball/v2_beta.1"
    )
pkg_bases=(
    "openexr-trunk"
    "openexr-openexr-93484b1"
    )

pkg_info="OpenEXR is a high dynamic-range (HDR) image file format developed by Industrial Light & Magic for use in computer imaging applications."

pkg_desc="OpenEXR is a high dynamic-range (HDR) image file format developed by 
Industrial Light & Magic for use in computer imaging applications.

OpenEXR is used by ILM on all motion pictures currently in production. 
The first movies to employ OpenEXR were Harry Potter and the Sorcerers Stone, 
Men in Black II, Gangs of New York, and Signs. Since then, OpenEXR has become 
ILM's main image file format."

pkg_reqs="zlib lcms2 "
if [[ "$pkg_default" == "trunk" ]]; then
    pkg_reqs+="ilmbase/trunk "
else
    pkg_reqs+="ilmbase "
fi

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

ilm_subs=("Half" "IlmThread" "Imath" "ImathTest" "Iex" "IexMath" "IexTest" "OpenEXR")
for sub_inc in ${ilm_subs[@]}
do
    ilm_cflags+=":-I$BLDR_ILMBASE_INCLUDE_PATH/$sub_inc "
done

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

pkg_uses="$pkg_reqs"

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

    pkg_ldflags="$ilm_ldflags "
    pkg_cflags="$ilm_cflags "
    pkg_cflags+=":-I$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$pkg_base/OpenEXR/IlmImf"

    pkg_opts="cmake skip-boot force-serial-build "

    if [[ "$pkg_base" != "trunk" ]]; then
        pkg_opts+="use-base-dir=$pkg_base "
        pkg_cfg_path="$pkg_base/OpenEXR"
    else
        pkg_cfg_path="OpenEXR"
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


