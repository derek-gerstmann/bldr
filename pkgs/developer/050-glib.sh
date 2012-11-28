#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="glib"

pkg_default="2.32.4"
pkg_variants=("2.32.4")
pkg_mirrors=("http://ftp.gnome.org/pub/GNOME/sources/glib/2.32")

pkg_info="GLib provides the core application building blocks for libraries and applications written in C."

pkg_desc="GLib provides the core application building blocks for libraries and applications written in C. 
It provides the core object system used in GNOME, the main loop implementation, and a large set of 
utility functions for strings and common data structures."

pkg_opts="configure enable-static enable-shared"

pkg_reqs="libtool "
pkg_reqs+="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="pcre "
pkg_reqs+="libelf "
pkg_reqs+="libicu "
pkg_reqs+="libxml2 "
pkg_reqs+="libffi "
pkg_reqs+="gettext "
pkg_reqs+="libiconv "
pkg_reqs+="python "
pkg_reqs+="perl "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                  \
    --category    "$pkg_ctry"     \
    --name        "$pkg_name"     \
    --version     "$pkg_default"  \
    --requires    "$pkg_reqs"     \
    --uses        "$pkg_uses"     \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
if [[ $BLDR_SYSTEM_IS_64BIT == true ]]
then
     pkg_cflags+="-m64 "
fi

glb_cfg="--disable-maintainer-mode "
glb_cfg+="--disable-dependency-tracking "
glb_cfg+="--disable-dtrace " 
glb_cfg+="--with-pcre=system "
if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    glb_cfg+="--with-libiconv=native "
else
    glb_cfg+="--with-libiconv=gnu "
fi
pkg_patch=""

export PCRE_CFLAGS="-I$BLDR_PCRE_INCLUDE_PATH " 
export PCRE_LIBS="-L$BLDR_PCRE_LIB_PATH -lpcre -lpcrecpp "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.xz"
    pkg_host=${pkg_mirrors[$pkg_idx]}
    pkg_urls="$pkg_host/$pkg_file"
    
    pkg_cfg="$glb_cfg "
    pkg_cfg+="--sysconfdir=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/etc"

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

    let pkg_idx++
done

####################################################################################################

