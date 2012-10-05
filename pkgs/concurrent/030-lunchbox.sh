#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="concurrent"
pkg_name="lunchbox"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="A concurrency toolbox, since the free lunch is over."

pkg_desc="A concurrency toolbox, since the free lunch is over.  Used internally by Eyescale's 
Collage networking framework."

pkg_opts="cmake force-inplace-build"
pkg_reqs="cmake tar boost"
pkg_uses="boost"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                   \
  --category    "$pkg_ctry"        \
  --name        "$pkg_name"        \
  --version     "$pkg_default"     \
  --requires    "$pkg_reqs"        \
  --uses        "$pkg_uses"        \
  --options     "$pkg_opts"

####################################################################################################

export BOOST_ROOT=$BLDR_BOOST_BASE_PATH
export BOOST_INCLUDEDIR=$BLDR_BOOST_INCLUDE_PATH

pkg_cfg="-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg+=":-DBOOST_INCLUDEDIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg+=":-DBoost_NO_SYSTEM_PATHS=ON"
pkg_cfg+=":-DBoost_NO_BOOST_CMAKE=ON"
pkg_cfg+=":-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg+=":-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\""

pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.bz2"
    pkg_urls="git://github.com/Eyescale/Lunchbox.git"

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
