#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="cogl"

pkg_default="1.10.4"
pkg_variants=("1.10.4")

pkg_info="Cogl is a modern 3D graphics API with associated utility APIs designed to expose the features of 3D graphics hardware using a direct state access API design, as opposed to the state-machine style of OpenGL."

pkg_desc="Cogl is a modern 3D graphics API with associated utility APIs designed to 
expose the features of 3D graphics hardware using a direct state access API design, 
as opposed to the state-machine style of OpenGL. It is implemented in the C programming 
language but we want to provide bindings for everyone's favorite language too."
 
pkg_opts="configure enable-static enable-shared"

pkg_reqs="zlib "
pkg_reqs+="libtool "
pkg_reqs+="libxml2 "
pkg_reqs+="libicu "
pkg_reqs+="libiconv "
pkg_reqs+="gettext "
pkg_reqs+="glib "
pkg_reqs+="gtk-doc "
pkg_reqs+="pango "
pkg_uses="$pkg_reqs"

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
     pkg_reqs+="libpng "
fi

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg_path=""
pkg_cflags="-I$BLDR_GLIB_INCLUDE_PATH/glib-2.0 "
pkg_ldflags=""

pkg_cfg="--disable-introspection --disable-glibtest "
pkg_cfg+="--disable-cairo --enable-cogl-pango=no "

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_cfg+="--with-flavour=osx "
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cfg+="--with-flavour=linux"
     pkg_cflags+="-fPIC "    
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.xz"
    pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/cogl/1.10/$pkg_file"

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

