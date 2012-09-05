#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="f03gl"
pkg_vers="2003"

pkg_info="The F03GL library provides a Fortran 2003 interface to the OpenGL library, along with the GLU and GLUT toolkits."

pkg_desc="The F03GL library provides a Fortran 2003 interface to the OpenGL library, along with 
the GLU and GLUT toolkits. It has been developed by Anthony Stone and Aleksandar Donev. We have 
already received useful feedback from several users of this library, and we are grateful for their 
suggestions. There is still room for improvement, and we would be glad to receive further comments and bug reports."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www-stone.ch.cam.ac.uk/pub/f03gl/f03gl.tgz"
pkg_opts="configure force-serial-build skip-config skip-install migrate-build-tree migrate-build-bin migrate-build-headers"
pkg_uses="freeglut/latest gfortran/latest"
pkg_reqs="$pkg_uses"
pkg_cfg="--enable-shared --enable-static"
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name uses the native OSX version bundled with MacOSX.  Skipping..."
     bldr_log_split
else
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
fi

