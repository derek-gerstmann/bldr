#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="lttng-tools"

pkg_default="2.0.4"
pkg_variants=("2.0.4")

pkg_info="Linux Trace Toolkit next generation tools (LTTng-tools) provides efficient tracing tools for Linux."

pkg_desc="Linux Trace Toolkit next generation tools (LTTng-tools) provides efficient tracing tools for Linux.

The LTTng project aims at providing highly efficient tracing tools for Linux. It's tracers 
help tracking down performance issues and debugging problems involving multiple concurrent 
processes and threads. Tracing across multiple systems is also possible.

The lttng command line tool from the lttng-tools package is used to control both kernel 
and user-space tracing. Every interactions with the tracer should be done by this tool 
or by the liblttng-ctl provided with the lttng-tools package."

pkg_opts="configure "
pkg_opts+="enable-shared "
pkg_opts+="enable-static "

pkg_reqs="liburcu "
pkg_reqs+="lttng-ust "
pkg_reqs+="babeltrace "
pkg_reqs+="glib "
pkg_reqs+="zlib "
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

pkg_cflags="-I$BLDR_ZLIB_INCLUDE_PATH"
pkg_ldflags="-L$BLDR_ZLIB_LIB_PATH"

pkg_cflags="$pkg_cflags:-I$BLDR_LTTNG_UST_INCLUDE_PATH"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LTTNG_UST_LIB_PATH"

pkg_cfg="--with-babeltrace-bin=$BLDR_BABELTRACE_BIN_PATH"

####################################################################################################
# register pkg with bldr
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
     bldr_log_split
else
     for pkg_vers in ${pkg_variants[@]}
     do
          pkg_file="$pkg_name-$pkg_vers.tar.bz2"
          pkg_urls="http://lttng.org/files/$pkg_name/$pkg_file"

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
fi

####################################################################################################
