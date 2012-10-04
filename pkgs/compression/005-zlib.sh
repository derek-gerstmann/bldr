#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="zlib"

pkg_info="ZLIB is a massively spiffy yet delicately unobtrusive compression library"

pkg_desc="ZLIB is designed to be a free, general-purpose, legally unencumbered --  
that is, not covered by any patents -- lossless data-compression library for use on 
virtually any computer hardware and operating system. The zlib data format is itself 
portable across platforms. Unlike the LZW compression method used in Unix compress(1) 
and in the GIF image format, the compression method currently used in zlib essentially 
never expands the data. (LZW can double or triple the file size in extreme cases.) 
zlib's memory footprint is also independent of the input data and can be reduced, if 
necessary, at some cost in compression. A more precise, technical discussion of both 
points is available on another page."

pkg_vers_dft="1.2.7"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure --enable-shared skip-auto-compile-flags config-prepend-env"
pkg_uses="m4 autoconf automake"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="-t"

if [[ $BLDR_SYSTEM_IS_64BIT == true ]]
then
    pkg_cfg="$pkg_cfg -64"
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    export CFLAGS="-fPIC"
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
      pkg_file="$pkg_name-$pkg_vers.tar.gz"
      pkg_urls="http://zlib.net/$pkg_file"

      bldr_register_pkg               \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_vers_dft"\
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


