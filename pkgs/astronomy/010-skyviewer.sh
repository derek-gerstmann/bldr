#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="astronomy"
pkg_name="skyviewer"

pkg_default="1.0.0"
pkg_variants=("1.0.0")
pkg_mirrors=("http://pkgs.fedoraproject.org/repo/pkgs/skyviewer/skyviewer-1.0.0.tar.gz/1fc1a1f45d92fa09699a5869f6f2df4e")

pkg_info="Skyviewer is an OpenGL based program to display HEALPix based skymaps, saved in FITS format files."

pkg_desc="Skyviewer is an OpenGL based program to display HEALPix based skymaps, saved
in FITS format files. The loaded skymaps can be viewed either on a 3D
sphere or as a Mollweide projection. In either case, realtime panning and
zooming are supported, along with rotations for the 3D sphere view,
assuming you have a strong enough graphics card.

This version of Skyviewer represents a major redesign and improvement
over previous versions.  Any comments or suggestions will be greatly
appreciated!"

pkg_opts="qmake"

pkg_reqs="qt qglviewer cfitsio healpix-c"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg_path="QGLViewer"

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
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_host=${pkg_mirrors[$pkg_idx]}
    pkg_urls="$pkg_host/$pkg_file"

    pkg_cfg="INCLUDE_DIR=$BLDR_QGLVIEWER_INCLUDE_PATH "
#    pkg_cfg+="INCLUDE_DIR=$BLDR_CFITSIO_INCLUDE_PATH "
#    pkg_cfg+="INCLUDE_DIR=$BLDR_HEALPIX_C_INCLUDE_PATH "

    pkg_cfg+="LIB_DIR=$BLDR_QGLVIEWER_LIB_PATH "
#    pkg_cfg+="LIB_DIR=$BLDR_CFITSIO_LIB_PATH "
#    pkg_cfg+="LIB_DIR=$BLDR_HEALPIX_C_LIB_PATH "

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
