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
pkg_vers="0.8"

pkg_info="io-watchdog is a facility for monitoring user applications and parallel jobs for hangs."

pkg_desc="io-watchdog is a facility for monitoring user applications and parallel jobs for hangs.

Such issues typically have a side effect of ceasing all IO in a cyclic application (i.e. one 
that writes something to a log or data file during each cycle of computation). The io-watchdog 
attempts to watch all IO coming from an application and triggers a set of user-defined actions w
hen IO has stopped for a configurable timeout period."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="https://io-watchdog.googlecode.com/files/$pkg_file"
pkg_opts="configure force-serial-build"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--enable-static --enable-shared"

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
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

