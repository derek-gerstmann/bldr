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

pkg_default="4.6.0"
pkg_variants=("4.6.0")

pkg_info="Gnuplot is a portable command-line driven graphing utility for Linux, OS/2, MS Windows, OSX, VMS, and many other platforms."

pkg_desc="Gnuplot is a portable command-line driven graphing utility for Linux, OS/2, MS Windows, OSX, VMS, and many other platforms. 

The source code is copyrighted but freely distributed (i.e., you don't have to pay for it). 

It was originally created to allow scientists and students to visualize mathematical functions 
and data interactively, but has grown to support many non-interactive uses such as web scripting. 

It is also used as a plotting engine by third-party applications like Octave. Gnuplot has been 
supported and under active development since 1986."

pkg_opts="configure enable-static enable-shared"

pkg_reqs="pkg-config "
pkg_reqs+="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="libxml2 "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="gettext "
pkg_reqs+="glib "
pkg_reqs+="gtk-doc "
pkg_reqs+="pango "
pkg_reqs+="qt "
pkg_reqs+="gd "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--without-x --without-wxt "
pkg_cfg+="--enable-qt "
pkg_cfg_path=""

pkg_cflags=""
pkg_ldflags="-L\"$BLDR_LIBICONV_LIB_PATH\" -liconv "
pkg_ldflags+="\"$BLDR_ZLIB_LIB_PATH/libz.a\" "
pkg_ldflags+="-L\"$BLDR_BZIP2_LIB_PATH\" -lbz2 "

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
     pkg_reqs+="libpng "
     pkg_ldflags+="-L\"$BLDR_LIBPNG_LIB_PATH\" -lpng "
fi


####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://downloads.sourceforge.net/project/$pkg_name/$pkg_name/$pkg_vers/$pkg_file"

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

    let pkg_idx++
done

####################################################################################################
