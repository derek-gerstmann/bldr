#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="gtk"

pkg_default="3.4.4"
pkg_variants=("3.4.4")

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

pkg_opts="configure"
pkg_reqs+="zlib "
pkg_reqs+="libxml2 "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="glib "
pkg_reqs+="libpng "
pkg_reqs+="pango "
pkg_reqs+="cairo "
pkg_reqs+="atk "
pkg_reqs+="gdk-pixbuf "
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

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_cfg+="--with-gdktarget=quartz "
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="gtk+-$pkg_vers.tar.xz"
    pkg_urls="http://ftp.gnome.org/pub/gnome/sources/gtk+/3.4/$pkg_file"

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
