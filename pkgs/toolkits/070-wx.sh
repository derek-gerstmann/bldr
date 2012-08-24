#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers_list=("2.8.12" "2.9.4")
pkg_ctry="toolkits"
pkg_name="wx"
pkg_vers="3.4.4"

pkg_info="WX is a C++ Widgets library that lets developers create GUI applications for many platforms."

pkg_desc="wxWidgets is a C++ library that lets developers create applications for Windows, 
OS X, Linux and UNIX on 32-bit and 64-bit architectures as well as several mobile 
platforms including Windows Mobile, iPhone SDK and embedded GTK+.

It has popular language bindings for Python, Perl, Ruby and many other languages. 
Unlike other cross-platform toolkits, wxWidgets gives its applications a truly native 
look and feel because it uses the platform's native API rather than emulating the GUI. 
It's also extensive, free, open-source and mature."

pkg_file="wxWidgets-$pkg_vers-src.tar.bz2"
pkg_urls="http://prdownloads.sourceforge.net/wxwindows/$pkg_file"
pkg_opts="configure"
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libiconv/latest"
pkg_reqs="$pkg_reqs glib/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_reqs="$pkg_reqs pango/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in "${pkg_ver_list[@]}"
do
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
                 --config      "$pkg_cfg"     \
                 --config-path "$pkg_cfg_path"
done

