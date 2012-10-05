#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="lttng-ust"

pkg_default="2.0.5"
pkg_variants=("2.0.5")

pkg_info="Linux Trace Toolkit next generation userspace tracer (LTTng-UST) is designed to provide detailed information about userspace 
activity."

pkg_desc="Linux Trace Toolkit next generation userspace tracer (LTTng-UST) 
is designed to provide detailed information about userspace activity. UST is 
a port of the LTTng kernel tracer to userspace. Like the LTTng kernel 
tracer, performance is the main goal. Tracing does not require system calls or traps. 
UST instrumentation points may be added in any userspace code including signal 
handlers and libraries­."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_cfg=""
pkg_reqs="liburcu"
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""

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
