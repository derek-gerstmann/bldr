#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="gnuplot"
pkg_vers="4.6.0"

pkg_info="Gnuplot is a portable command-line driven graphing utility for Linux, OS/2, MS Windows, OSX, VMS, and many other platforms."

pkg_desc="Gnuplot is a portable command-line driven graphing utility for Linux, OS/2, MS Windows, OSX, VMS, and many other platforms. 

The source code is copyrighted but freely distributed (i.e., you don't have to pay for it). 

It was originally created to allow scientists and students to visualize mathematical functions 
and data interactively, but has grown to support many non-interactive uses such as web scripting. 

It is also used as a plotting engine by third-party applications like Octave. Gnuplot has been 
supported and under active development since 1986."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://downloads.sourceforge.net/project/$pkg_name/$pkg_name/$pkg_vers/$pkg_file"
pkg_opts="configure"

pkg_reqs=""
pkg_reqs="$pkg_reqs pkg-config/latest"
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libiconv/latest"
pkg_reqs="$pkg_reqs gettext/latest"
pkg_reqs="$pkg_reqs glib/latest"
pkg_reqs="$pkg_reqs gtk-doc/latest"
pkg_reqs="$pkg_reqs pango/latest"
pkg_uses="$pkg_reqs"

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
     pkg_reqs="$pkg_reqs libpng/latest"
fi

pkg_cfg="--without-x"
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags="-liconv"

if [[ $BLDR_SYSTEM_IS_LINUX == true ]] 
then
     pkg_cflags="$pkg_cflags -fPIC"    
fi

pkg_uses="$pkg_reqs"

####################################################################################################
# build and install pkg as local module
####################################################################################################

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

