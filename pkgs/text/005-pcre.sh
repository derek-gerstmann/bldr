#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="pcre"

pkg_default="8.31"
pkg_variants=("8.31")

pkg_info="The PCRE package contains Perl Compatible Regular Expression libraries."

pkg_desc="The PCRE package contains Perl Compatible Regular Expression libraries. 

These are useful for implementing regular expression pattern matching using the same 
syntax and semantics as Perl 5. "

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_reqs="zlib "
pkg_reqs+="bzip2 "

pkg_uses="$pkg_reqs"

pkg_cfg="--enable-utf "
pkg_cfg+="--enable-pcregrep-libz "
pkg_cfg+="--enable-pcregrep-libbz2 "
pkg_cfg+="--enable-unicode-properties "

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="ftp://ftp.csx.cam.ac.uk/pub/software/programming/$pkg_name/$pkg_file"

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
