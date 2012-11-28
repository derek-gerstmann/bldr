#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="typography"
pkg_name="pango"

pkg_default="1.30.1"
pkg_variants=("1.30.1")

pkg_info="Pango is a library for laying out and rendering of text, with an emphasis on internationalization."

pkg_desc="Pango is a library for laying out and rendering of text, with an emphasis on 
internationalization. Pango can be used anywhere that text layout is needed, though most 
of the work on Pango so far has been done in the context of the GTK+ widget toolkit. 
Pango forms the core of text and font handling for GTK+-2.x.

Pango is designed to be modular; the core Pango layout engine can be used with different 
font backends. There are three basic backends, with multiple options for rendering with each.

Client side fonts using the FreeType and fontconfig libraries. Rendering can be with with 
Cairo or Xft libraries, or directly to an in-memory buffer with no additional libraries.

Native fonts on Microsoft Windows using Uniscribe for complex-text handling. Rendering 
can be done via Cairo or directly using the native Win32 API.

Native fonts on MacOS X using ATSUI for complex-text handling, rendering via Cairo.

The integration of Pango with Cairo (http://cairographics.org/) provides a complete solution
 with high quality text handling and graphics rendering.

Dynamically loaded modules then handle text layout for particular combinations of script and 
font backend. Pango ships with a wide selection of modules, including modules for 
Hebrew, Arabic, Hangul, Thai, and a number of Indic scripts. Virtually all of the world's 
major scripts are supported.

As well as the low level layout rendering routines, Pango includes PangoLayout, a high 
level driver for laying out entire blocks of text, and routines to assist in editing 
internationalized text.

Pango depends on 2.x series of the GLib library; more information about GLib can be 
found at http://www.gtk.org/."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_reqs="libtool "
pkg_reqs+="perl "
pkg_reqs+="glib "
pkg_reqs+="gobject-isl "
pkg_reqs+="zlib "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="libxml2 "
pkg_reqs+="freetype "
pkg_reqs+="fontconfig "
pkg_reqs+="harfbuzz "
pkg_reqs+="gettext "
pkg_reqs+="gtk-doc "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                  \
  --category    "$pkg_ctry"       \
  --name        "$pkg_name"       \
  --version     "$pkg_default"    \
  --requires    "$pkg_reqs"       \
  --uses        "$pkg_uses"       \
  --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--enable-introspection "
pkg_cfg="--enable-gtk-doc "
pkg_cflags="-I$BLDR_GLIB_BASE_PATH/include "
pkg_cflags+="-I$BLDR_GLIB_BASE_PATH/include/glib-2.0 "
pkg_cflags+="-I$BLDR_GLIB_BASE_PATH/include/gio-unix-2.0 "
pkg_ldflags=""

export HARFBUZZ_CFLAGS="-I$BLDR_HARFBUZZ_INCLUDE_PATH -I$BLDR_HARFBUZZ_INCLUDE_PATH/harfbuzz "
export HARFBUZZ_LIBS="-L$BLDR_HARFBUZZ_LIB_PATH -lharfbuzz "

export FREETYPE_CFLAGS="-I$BLDR_FREETYPE_INCLUDE_PATH -I$BLDR_FREETYPE_INCLUDE_PATH/freetype2 "
export FREETYPE_LIBS="-I$BLDR_FREETYPE_LIB_PATH -lfreetype "

export FONTCONFIG_CFLAGS="-I$BLDR_FONTCONFIG_INCLUDE_PATH "
export FONTCONFIG_LIBS="-I$BLDR_FONTCONFIG_LIB_PATH -lfontconfig "

export GLIB_CFLAGS="-I$BLDR_GLIB_BASE_PATH/include -I$BLDR_GLIB_BASE_PATH/include/glib-2.0 -I$BLDR_GLIB_BASE_PATH/include/gio-unix-2.0 " 
export GLIB_LIBS="-L$BLDR_GLIB_LIB_PATH -lglib-2.0 -lgio-2.0 -lgmodule-2.0 -lgobject-2.0 -lgthread-2.0 "

alias glib-mkenums=$BLDR_GLIB_BASE_PATH/bin/glib-mkenums

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.xz"
    pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/$pkg_name/1.30/$pkg_file"

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

