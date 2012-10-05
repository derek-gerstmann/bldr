#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="wx"

pkg_default="2.9.4"
pkg_variants=("2.9.4")

pkg_info="WX is a C++ Widgets library that lets developers create GUI applications for many platforms."

pkg_desc="wxWidgets is a C++ library that lets developers create applications for Windows, 
OS X, Linux and UNIX on 32-bit and 64-bit architectures as well as several mobile 
platforms including Windows Mobile, iPhone SDK and embedded GTK+.

It has popular language bindings for Python, Perl, Ruby and many other languages. 
Unlike other cross-platform toolkits, wxWidgets gives its applications a truly native 
look and feel because it uses the platform's native API rather than emulating the GUI. 
It's also extensive, free, open-source and mature."

pkg_opts="configure "

pkg_reqs+="zlib "
pkg_reqs+="libxml2 "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="glib "
pkg_reqs+="libpng "
pkg_reqs+="pango "
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

pkg_cfg=""
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="wxWidgets-$pkg_vers-src.tar.bz2"
    pkg_urls="http://prdownloads.sourceforge.net/wxwindows/$pkg_file"

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
