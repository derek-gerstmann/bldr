#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="gtk-doc"

pkg_default="1.18"
pkg_variants=("1.18")

pkg_info="GTK-Doc is a project which was started to generate API documentation from comments added to C code."

pkg_desc="GTK-Doc is a project which was started to generate API documentation from comments 
added to C code. It is typically used to document the public API of GTK+ and GNOME 
libraries, but it can also be used to document application code."

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
pkg_reqs+="libtool "
pkg_reqs+="zlib "
pkg_reqs+="libxslt "
pkg_reqs+="libxml2 "
pkg_reqs+="docbook-xsl "
pkg_reqs+="docbook-xml "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_default" \
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg="--with-xml-catalog=$XML_CATALOG_FILES"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/$pkg_name/$pkg_vers/$pkg_file"

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
done

####################################################################################################

