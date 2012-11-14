#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="services"
pkg_name="grape"

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="Grape is a pipeline engine to process data stored to elliptics."

pkg_desc="Grape is a pipeline engine to process data stored to elliptics."

pkg_opts="cmake "

pkg_reqs="zlib "
pkg_reqs+="boost "
pkg_reqs+="python "
pkg_reqs+="perl "
pkg_reqs+="cocaine-core "
pkg_reqs+="cocaine-plugins "
pkg_reqs+="eblob "
pkg_reqs+="elliptics "

pkg_uses="$pkg_reqs "

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

pkg_cflags="-I$BLDR_BOOST_INCLUDE_PATH "
pkg_ldflags="-L$BLDR_BOOST_LIB_PATH "

pkg_cflags+="-I$BLDR_COCAINE_CORE_INCLUDE_PATH "
pkg_cflags+="-I$BLDR_COCAINE_CORE_INCLUDE_PATH/cocaine "
pkg_ldflags+="-L$BLDR_COCAINE_CORE_LIB_PATH -lcocaine-common -lcocaine-core -ljson "

pkg_cflags+="-I$BLDR_COCAINE_PLUGINS_INCLUDE_PATH "
pkg_cflags+="-I$BLDR_COCAINE_PLUGINS_INCLUDE_PATH/cocaine "
pkg_ldflags+="-L$BLDR_COCAINE_PLUGINS_LIB_PATH "

pkg_cflags+="-I$BLDR_EBLOB_INCLUDE_PATH "
pkg_ldflags+="-L$BLDR_EBLOB_LIB_PATH -leblob "

pkg_cflags+="-I$BLDR_ELLIPTICS_INCLUDE_PATH "
pkg_cflags+="-I$BLDR_ELLIPTICS_INCLUDE_PATH/elliptics "
pkg_ldflags+="-L$BLDR_ELLIPTICS_LIB_PATH -lelliptics -lelliptics_cpp "

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    pkg_cflags+=" -fPIC "
fi

pkg_cfg="-DMONGO=OFF "
pkg_cfg+="-DJAVASCRIPT=OFF "

pkg_cfg+="-Dcocaine_INCLUDE_DIR=\"$BLDR_COCAINE_CORE_INCLUDE_PATH/cocaine\" "
pkg_cfg+="-Dcocaine_LIB_DIR=\"$BLDR_COCAINE_CORE_LIB_PATH\" "

pkg_cfg+="-Delliptics_INCLUDE_DIR=\"$BLDR_ELLIPTICS_INCLUDE_PATH/elliptics\" "
pkg_cfg+="-Delliptics_LIB_DIR=\"$BLDR_ELLIPTICS_LIB_PATH\" "

pkg_cfg+="-DCMAKE_C_FLAGS='$pkg_cflags $pkg_ldflags' "
pkg_cfg+="-DCMAKE_CXX_FLAGS='$pkg_incflags $pkg_ldflags' "
pkg_cfg+="-DBoost_NO_SYSTEM_PATHS=ON "
pkg_cfg+="-DBoost_NO_BOOST_CMAKE=ON "
pkg_cfg+="-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\" "
pkg_cfg+="-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\" "
pkg_cfg+="-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\" "
pkg_cfg+="-DBoost_DEBUG=OFF "
pkg_cfg+="-DBoost_FOUND=TRUE "
pkg_cfg+="-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\" "
pkg_cfg+="-DBoost_LIBRARY_DIRS=\"$BLDR_BOOST_LIB_PATH\" "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
    pkg_urls="git://github.com/reverbrain/grape.git"

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
