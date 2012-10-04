#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="babeltrace"

pkg_info="Babeltrace is a command-line tool and library to read and convert trace files to and from different formats."

pkg_desc="Babeltrace is a command-line tool and library to read and convert 
trace files to and from different formats. It supports the CTF format, which 
is outputted by the LTTng 2.0 tracers."

pkg_vers_dft="1.0.0-rc5"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_cfg=""

pkg_reqs="liburcu lttng-ust zlib"
pkg_uses=""

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_vers_dft"\
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags="-I$BLDR_ZLIB_INCLUDE_PATH"
pkg_ldflags="-L$BLDR_ZLIB_LIB_PATH"

pkg_cflags="$pkg_cflags:-I$BLDR_LTTNG_UST_INCLUDE_PATH"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LTTNG_UST_LIB_PATH"

####################################################################################################
# register pkg with bldr
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
     bldr_log_split
else
     for pkg_vers in ${pkg_vers_list[@]}
     do
          pkg_file="$pkg_name-$pkg_vers.tar.bz2"
          pkg_urls="http://lttng.org/files/$pkg_name/$pkg_file"

          bldr_register_pkg                 \
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
fi

####################################################################################################
