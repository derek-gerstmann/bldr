#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="libicu"

pkg_default="49.1.2"
pkg_variants=("$pkg_default")
pkg_distribs=("icu4c-49_1_2-src.tgz")
pkg_mirrors=("http://download.icu-project.org/files/icu4c/49.1.2")

pkg_info="ICU is the premier library for software internationalization."

pkg_desc="ICU is the premier library for software internationalization.

ICU is a mature, widely used set of C/C++ and Java libraries providing Unicode and 
Globalization support for software applications. ICU is widely portable and gives 
applications the same results on all platforms and between C/C++ and Java software.
ICU is released under a nonrestrictive open source license that is suitable for use 
with both commercial software and with other open source or free software."

pkg_opts="configure "
pkg_opts+="force-serial-build "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_reqs="zlib"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path="source"

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    export THE_OS="MacOSX"
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    export THE_OS="Linux"
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file=${pkg_distribs[$pkg_idx]}
    pkg_urls=${pkg_mirrors[$pkg_idx]}
    pkg_urls+="/$pkg_file"

    pkg_cflags="-I$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/source"

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

    let pkg_idx++
done

####################################################################################################
