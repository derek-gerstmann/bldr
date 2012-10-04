#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="io-watchdog"

pkg_info="io-watchdog is a facility for monitoring user applications and parallel jobs for hangs."

pkg_desc="io-watchdog is a facility for monitoring user applications and parallel jobs for hangs.

Such issues typically have a side effect of ceasing all IO in a cyclic application (i.e. one 
that writes something to a log or data file during each cycle of computation). The io-watchdog 
attempts to watch all IO coming from an application and triggers a set of user-defined actions w
hen IO has stopped for a configurable timeout period."

pkg_vers_dft="0.8"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure force-serial-build enable-static enable-shared"
pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

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
          pkg_urls="https://io-watchdog.googlecode.com/files/$pkg_file"

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
