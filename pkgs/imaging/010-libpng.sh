#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="libpng"

pkg_default="1.5.12"
pkg_variants=("1.2.50" "1.5.12")

pkg_info="PNG is an open, extensible image format with lossless compression."

pkg_desc="PNG is an open, extensible image format with lossless compression.
Libpng is the official PNG reference library. It supports almost all PNG 
features, is extensible, and has been extensively tested for over 16 years."

pkg_opts="configure "
if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_opts+="force-static "
else
    pkg_opts+="enable-static "
    pkg_opts+="enable-shared "
fi

pkg_reqs="zlib libtool"
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

pkg_cfg="--with-zlib-prefix=\"$BLDR_ZLIB_BASE_PATH\" "
pkg_cfg+="--with-pkgconfigdir=\"$PKG_CONFIG_PATH\" "

pkg_cflags=""
pkg_ldflags="-L\"$BLDR_ZLIB_LIB_PATH\" -lz"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://prdownloads.sourceforge.net/libpng/$pkg_file?download"

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
