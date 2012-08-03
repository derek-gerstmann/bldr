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
pkg_vers="1.0.0-rc4"

pkg_info="Babeltrace is a command-line tool and library to read and convert trace files to and from different formats."

pkg_desc="Babeltrace is a command-line tool and library to read and convert 
trace files to and from different formats. It supports the CTF format, which 
is outputted by the LTTng 2.0 tracers."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://lttng.org/files/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs="liburcu/latest lttng-ust/latest"
pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest zlib/latest"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/tracing/lttng-ust/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/tracing/lttng-ust/latest/lib"

pkg_cfg="--enable-static --enable-shared"

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX -eq 1 ]
then
     bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
     bldr_log_split
else
     bldr_build_pkg --category    "$pkg_ctry"    \
                    --name        "$pkg_name"    \
                    --version     "$pkg_vers"    \
                    --info        "$pkg_info"    \
                    --description "$pkg_desc"    \
                    --file        "$pkg_file"    \
                    --url         "$pkg_urls"    \
                    --uses        "$pkg_uses"    \
                    --requires    "$pkg_reqs"    \
                    --options     "$pkg_opts"    \
                    --cflags      "$pkg_cflags"  \
                    --ldflags     "$pkg_ldflags" \
                    --config      "$pkg_cfg"
fi

