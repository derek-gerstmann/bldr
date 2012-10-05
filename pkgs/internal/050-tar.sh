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

pkg_default="1.26"
pkg_variants=("1.26")

pkg_info="GNU tar creates and manipulates archives which are actually collections of many other files."

pkg_desc="GNU tar creates and manipulates archives which are actually collections of many other files; 
the program provides users with an organized and systematic method for controlling a large amount 
of data. The name “tar” originally came from the phrase 'Tape ARchive', but archives need not 
(and these days, typically do not) reside on tapes."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="coreutils gzip zlib xz bzip2"
pkg_uses="$pkg_reqs"

pkg_cfg="--with-xz=$BLDR_LOCAL_PATH/compression/xz/default/bin/xz "
pkg_cfg+="--with-lzip=$BLDR_LOCAL_PATH/compression/zlib/default/lib/libz.a "
pkg_cfg+="--with-gzip=$BLDR_LOCAL_PATH/compression/gzip/default/bin/gzip "
pkg_cfg+="--with-bzip2=$BLDR_LOCAL_PATH/compression/bzip2/default/bin/bzip2 "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftp.gnu.org/gnu/tar/$pkg_file"

     bldr_register_pkg                \
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

