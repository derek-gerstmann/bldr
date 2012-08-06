#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="system"
pkg_name="liburcu"
pkg_vers="0.7.3"

pkg_info="Userspace RCU (liburcu) is a LGPLv2.1 userspace RCU (read-copy-update) library."

pkg_desc="Userspace RCU (liburcu) is a LGPLv2.1 userspace RCU (read-copy-update) library. 
This data synchronization library provides read-side access which scales linearly with 
the number of cores. It does so by allowing multiples copies of a given data structure 
to live at the same time, and by monitoring the data structure accesses to detect grace 
periods after which memory reclamation is possible.

liburcu-cds provides efficient data structures based on RCU and lock-free algorithms. 
Those structures include hash tables, queues, stacks, and doubly-linked lists.

The liburcu project has been started by Mathieu Desnoyers."

pkg_file="userspace-rcu-$pkg_vers.tar.bz2"
pkg_urls="http://lttng.org/files/urcu/$pkg_file"
pkg_opts="configure"
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
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

