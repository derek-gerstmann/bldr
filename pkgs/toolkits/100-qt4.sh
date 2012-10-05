#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="qt"

pkg_default="4.8.3"
pkg_variants=("4.8.3")

pkg_info="Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language."

pkg_desc="Qt is a cross-platform application and UI framework for developers using C++ or QML, 
a CSS & JavaScript like language"

pkg_opts="configure "
pkg_opts+="skip-auto-compile-flags "

pkg_reqs=""
pkg_reqs+="zlib "
pkg_reqs+="bison "
pkg_reqs+="flex "
pkg_reqs+="gperf "
pkg_reqs+="openssl "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="libedit "
pkg_reqs+="perl "
pkg_reqs+="python "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_vers"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-opensource "
pkg_cfg+="-release "
pkg_cfg+="-continue "
pkg_cfg+="-silent "
pkg_cfg+="-confirm-license "
pkg_cfg+="-fast " 

pkg_cfg+="-make libs "
pkg_cfg+="-make tools "
pkg_cfg+="-no-webkit "
pkg_cfg+="-no-libmng "
pkg_cfg+="-qt-zlib "
pkg_cfg+="-openssl-linked "
pkg_cfg+="-I \"$BLDR_ZLIB_INCLUDE_PATH\" "
pkg_cfg+="-I \"$BLDR_FLEX_INCLUDE_PATH\" "
pkg_cfg+="-I \"$BLDR_OPENSSL_INCLUDE_PATH\" "
pkg_cfg+="-I \"$BLDR_LIBICU_INCLUDE_PATH\" "
pkg_cfg+="-I \"$BLDR_LIBICONV_INCLUDE_PATH\" "
pkg_cfg+="-I \"$BLDR_LIBEDIT_INCLUDE_PATH\" "
pkg_cfg+="-L \"$BLDR_ZLIB_LIB_PATH\" "
pkg_cfg+="-L \"$BLDR_BISON_LIB_PATH\" "
pkg_cfg+="-L \"$BLDR_FLEX_LIB_PATH\" "
pkg_cfg+="-L \"$BLDR_OPENSSL_LIB_PATH\" "
pkg_cfg+="-L \"$BLDR_LIBICU_LIB_PATH\" "
pkg_cfg+="-L \"$BLDR_LIBICONV_LIB_PATH\" "
pkg_cfg+="-L \"$BLDR_LIBEDIT_LIB_PATH\" "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="qt-everywhere-opensource-src-$pkg_vers.tar.gz"
    pkg_urls="http://origin.releases.qt-project.org/qt4/source/$pkg_file"

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
