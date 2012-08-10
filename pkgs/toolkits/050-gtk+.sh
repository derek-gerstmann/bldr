#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="gtk+"
pkg_vers="3.4.4"

pkg_info="GTK+ is a multi-platform toolkit for creating graphical user interfaces."

pkg_desc="GTK+ is a multi-platform toolkit for creating graphical user interfaces. 

Offering a complete set of widgets, GTK+ is suitable for projects ranging from 
small one-off tools to complete application suites.

* Where can I use it?

Everywhere! GTK+ is cross-platform and boasts an easy to use API, speeding up your 
development time. Take a look at the screenshots to see a number of platforms GTK+ will run.

* What languages are supported?

GTK+ is written in C but has been designed from the ground up to support a wide 
range of languages, not only C/C++. Using GTK+ from languages such as Perl and 
Python (especially in combination with the Glade GUI builder) provides an effective 
method of rapid application development.

* Are there any licensing restrictions?

GTK+ is free software and part of the GNU Project. However, the licensing terms 
for GTK+, the GNU LGPL, allow it to be used by all developers, including those 
developing proprietary software, without any license fees or royalties."

pkg_file="$pkg_name-$pkg_vers-src.tar.gz"
pkg_urls="http://ftp.gnome.org/pub/gnome/sources/$pkg_name/3.4/$pkg_file"
pkg_opts="configure"
pkg_cfg=""
pkg_cfg_path=""

pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="compression/zlib text/libicu developer/libxml2"
dep_list="$dep_list text/gettext developer/glib"
dep_list="$dep_list imaging/png typography/pango"

if [[ $BLDR_SYSTEM_IS_OSX == false ]]; then
     dep_list="$dep_list text/libiconv"
fi

for dep_pkg in $dep_list
do
     pkg_req_name=$(echo "$dep_pkg" | sed 's/.*\///g' )
     pkg_reqs="$pkg_reqs $pkg_req_name/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cfg="$pkg_cfg --disable-x11-backend --enable-quartz-backend"
     pkg_cflags="$pkg_cflags:-I/usr/local/include:-I/usr/include"
     pkg_ldflags="$pkg_ldflags:-L/usr/local/lib:-L/usr/lib:-lintl"
fi

pkg_uses="$pkg_reqs"

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_path"


