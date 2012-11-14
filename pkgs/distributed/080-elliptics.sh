#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="elliptics"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="Elliptics network is a fault tolerant distributed key/value storage."

pkg_desc="Elliptics network is a fault tolerant distributed key/value storage."

pkg_opts="cmake "

pkg_reqs="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="eblob "
pkg_reqs+="smack "
pkg_reqs+="zeromq "
pkg_reqs+="cocaine-core "
pkg_reqs+="level-db "
pkg_reqs+="boost "
pkg_reqs+="python "
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


pkg_ldflags=""
pkg_cfg="-DWITH_COCAINE=ON "
pkg_cfg+="-DBoost_NO_SYSTEM_PATHS=ON "
pkg_cfg+="-DBoost_NO_BOOST_CMAKE=ON "
pkg_cfg+="-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\" "
pkg_cfg+="-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\" "
pkg_cfg+="-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\" "
pkg_cfg+="-DBoost_DEBUG=OFF "
pkg_cfg+="-DBoost_FOUND=TRUE "
pkg_cfg+="-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\" "
pkg_cfg+="-DBoost_LIBRARY_DIRS=\"$BLDR_BOOST_LIB_PATH\" "

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags+="-fPIC "
fi


####################################################################################################
# register each pkg version with bldr
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
     bldr_log_split
else
    for pkg_vers in ${pkg_variants[@]}
    do
        pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
        pkg_urls="git://github.com/reverbrain/elliptics.git"

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
fi

####################################################################################################
