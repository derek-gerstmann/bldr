#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="tk"
pkg_vers="8.5.12"

pkg_info="Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches."

pkg_desc="Tk is a graphical user interface toolkit that takes developing desktop applications to a higher 
level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other 
dynamic languages, and can produce rich, native applications that run unchanged across Windows, 
Mac OS X, Linux and more."

pkg_file="tk$pkg_vers-src.tar.gz"
pkg_urls="http://prdownloads.sourceforge.net/tcl/$pkg_file"
pkg_opts="configure force-serial-build"
pkg_uses="tcl/$pkg_vers"
pkg_reqs="$pkg_uses"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--with-tcl=$BLDR_LOCAL_PATH/languages/tcl/$pkg_vers"

if [[ $BLDR_SYSTEM_IS_OSX -eq 1 ]]; then
     pkg_cfg_path="macosx"
else
     pkg_cfg_path="unix"
fi

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_path"


