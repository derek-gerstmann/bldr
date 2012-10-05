#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="gdk-pixbuf"

pkg_default="2.26.2"
pkg_variants=("2.26.2")
pkg_mirrors=("http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.26")

pkg_info="GdkPixbuf is a library for image loading and manipulation."

pkg_desc="GdkPixbuf is a library for image loading and manipulation. The"

pkg_opts="configure force-bootstrap"
pkg_uses=""
pkg_reqs=""
pkg_cfg=""

pkg_reqs="zlib "
pkg_reqs+="libxml2 "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="gtk-doc "
pkg_reqs+="gettext "
pkg_reqs+="glib "
pkg_reqs+="libpng "
pkg_reqs+="libtiff "
pkg_reqs+="libjpeg "
pkg_reqs+="freetype "
pkg_reqs+="fontconfig "
pkg_reqs+="pixman "
pkg_reqs+="poppler "
if [[ $BLDR_SYSTEM_IS_OSX == false ]]; then
     pkg_reqs+="cogl "
fi

pkg_cfg=""
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cfg+="--disable-xlib --enable-quartz --enable-quartz-image "
else
     pkg_cfg+="--enable-cogl " 
     pkg_cflags+="-fPIC "    
fi

pkg_uses="$pkg_reqs"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.xz"
     pkg_host=${pkg_mirrors[$pkg_idx]}
     pkg_urls="$pkg_host/$pkg_file"

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

    let pkg_idx++
done

####################################################################################################

