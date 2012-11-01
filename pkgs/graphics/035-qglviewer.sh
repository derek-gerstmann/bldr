#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="qglviewer"

pkg_default="2.3.9"
pkg_variants=("2.3.9")
pkg_distribs=("libQGLViewer-2.3.9.tar.gz")

pkg_info="libQGLViewer is a C++ library based on Qt that eases the creation of OpenGL 3D viewers."

pkg_desc="libQGLViewer is a C++ library based on Qt that eases the creation of OpenGL 3D viewers. 

It provides some of the typical 3D viewer functionalities, such as the possibility to move the 
camera using the mouse, which lacks in most of the other APIs. Other features include mouse 
manipulated frames, interpolated keyFrames, object selection, stereo display, screenshot 
saving and much more. It can be used by OpenGL beginners as well as to create complex 
applications, being fully customizable and easy to extend.

Based on the Qt toolkit, it compiles on any architecture (Unix-Linux, Mac, Windows). 
Full reference documentation and many examples are provided. libQGLViewer does not display 
3D scenes in various formats, but it can be the base for the coding of such a viewer.

libQGLViewer uses dual licensing: it is freely available under the terms of the GNU-GPL 
license for open source software development, while commercial applications can apply for 
a commercial license."

pkg_opts="qmake"

pkg_reqs="qt"
pkg_uses="qt"

pkg_cflags=""
pkg_ldflags=""
if [ $BLDR_SYSTEM_IS_LINUX == true ]; then
  pkg_ldflags+="-lGLU "
fi
pkg_cfg_path="QGLViewer"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file=${pkg_distribs[$pkg_idx]}
    pkg_urls="http://www.libqglviewer.com/src/$pkg_file"

    pkg_cfg="LIB_DIR=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib "
    pkg_cfg+="DOC_DIR=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/share/doc "
    pkg_cfg+="DESTDIR=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib "

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
