#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="system"
pkg_name="libev"

pkg_default="4.11"
pkg_variants=("4.11")

pkg_info="LibEV is A full-featured and high-performance event loop that is loosely modelled after libevent, but without its limitations and bugs."

pkg_desc="LibEV is A full-featured and high-performance event loop that is loosely modelled 
after libevent, but without its limitations and bugs.

Features include child/pid watchers, periodic timers based on wallclock (absolute) time 
(in addition to timers using relative timeouts), as well as epoll/kqueue/event 
ports/inotify/eventfd/signalfd support, fast timer management, time jump detection 
and correction, and ease-of-use.

It can be used as a libevent replacement using its emulation API or directly embedded 
into your programs without the need for complex configuration support. A full-featured 
and well-documented perl interface is also available."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_uses="perl"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://dist.schmorp.de/libev/$pkg_file"

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

####################################################################################################
