#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="libelf"

pkg_default="0.8.13"
pkg_variants=("0.8.13")

pkg_info="LibELF lets you read, modify or create ELF files in an architecture-independent way."

pkg_desc="LibELF lets you read, modify or create ELF files in an architecture-independent way. 

The library takes care of size and endian issues, e.g. you can process a file for SPARC 
processors on an Intel-based system. This library is a clean-room rewrite of the 
System V Release 4 library and is supposed to be source code compatible with it. 

It was meant primarily for porting SVR4 applications to other operating systems but 
can also be used as the basis for new applications (and as a light-weight alternative 
to libbfd). "

pkg_opts="configure skip-xcode-config enable-static enable-shared"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.mr511.de/software/$pkg_file"

    bldr_register_pkg                \
        --category    "$pkg_ctry"    \
        --name        "$pkg_name"    \
        --version     "$pkg_vers"    \
        --default     "$pkg_default"\
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

