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
pkg_vers="1.18"
pkg_info="GTK-Doc is a project which was started to generate API documentation from comments added to C code."

pkg_desc="GTK-Doc is a project which was started to generate API documentation from comments 
added to C code. It is typically used to document the public API of GTK+ and GNOME 
libraries, but it can also be used to document application code."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/$pkg_name/$pkg_vers/$pkg_file"
pkg_opts="configure"
pkg_reqs=""
pkg_reqs="$pkg_reqs pkg-config/latest"
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs libxslt/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs docbook-xsl/latest"
pkg_reqs="$pkg_reqs docbook-xml/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_vers"    \
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg="--with-xml-catalog=$XML_CATALOG_FILES"

pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                 \
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

