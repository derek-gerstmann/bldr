#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="tar"
pkg_vers="1.26"

pkg_info="GNU tar creates and manipulates archives which are actually collections of many other files."

pkg_desc="GNU tar creates and manipulates archives which are actually collections of many other files; 
the program provides users with an organized and systematic method for controlling a large amount 
of data. The name “tar” originally came from the phrase 'Tape ARchive', but archives need not 
(and these days, typically do not) reside on tapes."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/tar/$pkg_file"
pkg_opts="configure"
pkg_reqs="coreutils/latest gzip/latest zlib/latest xz/latest bzip2/latest"
pkg_uses="$pkg_reqs"
pkg_cfg=""
pkg_cfg="$pkg_cfg --with-xz=$BLDR_LOCAL_PATH/compression/xz/latest/bin/xz"
pkg_cfg="$pkg_cfg --with-lzip=$BLDR_LOCAL_PATH/compression/zlib/latest/lib/libz.a"
pkg_cfg="$pkg_cfg --with-gzip=$BLDR_LOCAL_PATH/compression/gzip/latest/bin/gzip"
pkg_cfg="$pkg_cfg --with-bzip2=$BLDR_LOCAL_PATH/compression/bzip2/latest/bin/bzip2"

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


