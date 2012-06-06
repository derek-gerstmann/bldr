#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="pkgconfig"
pkg_vers="0.24"
pkg_base="pkg-config-0.24"
pkg_file="$pkg_base.tar.gz"
pkg_urls="http://pkgconfig.freedesktop.org/releases/$pkg_file"

pkg_opt="configure:keep"
pkg_cflags=0
pkg_ldflags=0
pkg_cfg="--disable-shared --enable-static"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg $pkg_name $pkg_vers $pkg_base $pkg_file $pkg_urls $pkg_opt $pkg_cflags $pkg_ldflags $pkg_cfg

####################################################################################################
# add subdirs to support our own version of PKGCFG for local package installs
####################################################################################################

if [ ! -d "$BLDR_LOCAL_DIR/$pkg_name/$pkg_vers/lib/pkgconfig" ]
then
    bldr_make_dir "$BLDR_LOCAL_DIR/$pkg_name/$pkg_vers/lib/pkgconfig"
    bldr_output_hline
fi