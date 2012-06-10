#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="tar"
pkg_vers="1.26"

pkg_info="GNU tar creates and manipulates archives which are actually collections of many other files."

pkg_desc="GNU tar creates and manipulates archives which are actually collections of many other files; 
the program provides users with an organized and systematic method for controlling a large amount 
of data. The name “tar” originally came from the phrase 'Tape ARchive', but archives need not 
(and these days, typically do not) reside on tapes."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/tar/$pkg_file"
pkg_opts="configure:keep"
pkg_reqs="m4/latest autoconf/latest automake/latest"
pkg_cfg="$pkg_cfg --with-xz=$BLDR_LOCAL_DIR/system/xz/bin/xz"
pkg_cfg="$pkg_cfg --with-lzip=$BLDR_LOCAL_DIR/system/zlib/lib/libz.a"
pkg_cfg="$pkg_cfg --with-gzip=$BLDR_LOCAL_DIR/system/gzip/bin/gzip"
pkg_cfg="$pkg_cfg --with-bzip2=$BLDR_LOCAL_DIR/system/bzip/bin/bzip2"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "system"       \
               --name        "$pkg_name"    \
               --version     "$pkg_vers"    \
               --info        "$pkg_info"    \
               --description "$pkg_desc"    \
               --file        "$pkg_file"    \
               --url         "$pkg_urls"    \
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"


