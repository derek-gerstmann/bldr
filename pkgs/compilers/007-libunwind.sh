#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="libunwind"

pkg_default="1.0.1"
pkg_variants=("1.0.1")

pkg_info="libunwind provides a portable and efficient C programming interface (API) to determine the call-chain of a program."

pkg_desc="libunwind provides a portable and efficient C programming interface (API) to determine the call-chain of a program.

A complete open-source implementation of the libunwind API currently exists for IA-64 Linux and is under development 
for Linux on x86, x86-64, and PPC64. Partial support for HP-UX and Linux on PA-RISC also exists.

The source-code is released under the MIT open source license. In the normal spirit of an open-source program, 
we encourage contributions and enhancements to this library. Particularly we would like to see libunwind support 
for other platforms (linux and non-linux, support for other processor architectures)."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="coreutils libelf"
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     bldr_log_warning "'$pkg_name/$pkg_vers' is not supported on OSX.  Skipping ..."
else
     for pkg_vers in ${pkg_variants[@]}
     do
          pkg_file="$pkg_name-$pkg_vers.tar.gz"
          pkg_urls="http://download.savannah.gnu.org/releases/$pkg_name/$pkg_file"

          bldr_register_pkg                 \
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
fi

####################################################################################################


