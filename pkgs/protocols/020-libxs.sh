#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="libxs"

pkg_info="Crossroads I/O provides lego bricks for building scalable and high performance distributed applications"

pkg_desc="Crossroads I/O provides lego bricks for building scalable and high performance 
distributed applications, and is what BSD sockets might have looked like if designed for 
today's requirements.  It is message based, and supports many different network protocols.  
LibXS works with all major programming languages, and all major operating systems.  
It is part of a wider effort to make messaging a standard part of the networking stack. 
It is Free Software licensed under the LGPL license, and is a fork of the ZeroMQ project."

pkg_vers_dft="1.2.0"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_cfg="-enable-libzmq" 

pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://download.crossroads.io/$pkg_file"

     bldr_register_pkg                  \
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
