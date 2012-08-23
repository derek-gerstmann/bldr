#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="cogl-pango"
pkg_vers="1.10.4"

pkg_info="Cogl is a modern 3D graphics API with associated utility APIs designed to expose the features of 3D graphics hardware using a direct state access API design, as opposed to the state-machine style of OpenGL."

pkg_desc="Cogl is a modern 3D graphics API with associated utility APIs designed to 
expose the features of 3D graphics hardware using a direct state access API design, 
as opposed to the state-machine style of OpenGL. It is implemented in the C programming 
language but we want to provide bindings for everyone's favorite language too."

pkg_file="cogl-$pkg_vers.tar.xz"
pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/cogl/1.10/$pkg_file"
pkg_opts="configure"

pkg_reqs=""
pkg_reqs="$pkg_reqs pkg-config/latest"
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libiconv/latest"
pkg_reqs="$pkg_reqs gettext/latest"
pkg_reqs="$pkg_reqs glib/latest"
pkg_reqs="$pkg_reqs gtk-doc/latest"
pkg_reqs="$pkg_reqs cairo/latest"
pkg_reqs="$pkg_reqs pango-cairo/latest"
pkg_uses="$pkg_reqs"

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
     pkg_reqs="$pkg_reqs libpng/latest"
fi
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

pkg_cfg="--disable-introspection --disable-glibtest"
pkg_cfg="$pkg_cfg --enable-cairo --enable-cogl-pango=yes"
if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_cfg="$pkg_cfg --with-flavour=osx"
fi
pkg_cfg_path=""
pkg_cflags="-I$BLDR_GLIB_INCLUDE_PATH/glib-2.0"
pkg_ldflags=""

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
               --config      "$pkg_cfg"

