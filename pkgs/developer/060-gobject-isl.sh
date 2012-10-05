#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="gobject-isl"
pkg_vers="1.32.1"

pkg_default="1.32.1"
pkg_variants=("1.32.1")
pkg_mirrors=("http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.32")

pkg_info="The GObject Introspection library is used to describe GLIB based program APIs and collect them in a uniform, machine readable format."

pkg_desc="The GObject Introspection library is used to describe the GLIB 
based program APIs and collect them in a uniform, machine readable format."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="pkg-config glib zlib gzip coreutils"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--disable-tests"
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="gobject-introspection-$pkg_vers.tar.xz"
     pkg_host=${pkg_mirrors[$pkg_idx]}
     pkg_urls="$pkg_host/$pkg_file"

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
