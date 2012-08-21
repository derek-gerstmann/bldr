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
pkg_info="The GObject Introspection library is used to describe GLIB based program APIs and collect them in a uniform, machine readable format."

pkg_desc="The GObject Introspection library is used to describe the GLIB 
based program APIs and collect them in a uniform, machine readable format."

pkg_file="gobject-introspection-$pkg_vers.tar.xz"
pkg_urls="http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.32/$pkg_file"
pkg_opts="configure"
pkg_reqs="pkg-config/latest glib/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--disable-tests"
pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                    \
     --category    "$pkg_ctry"    \
     --name        "$pkg_name"    \
     --version     "$pkg_vers"    \
     --info        "$pkg_info"    \
     --description "$pkg_desc"    \
     --file        "$pkg_file"    \
     --url         "$pkg_urls"    \
     --uses        "$pkg_uses"    \
     --requires    "$pkg_reqs"    \
     --options     "$pkg_opts"    \
     --patch       "$pkg_patch"   \
     --cflags      "$pkg_cflags"  \
     --ldflags     "$pkg_ldflags" \
     --config      "$pkg_cfg"

