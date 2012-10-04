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

pkg_vers_dft="8.5.12"
pkg_vers_list=("$pkg_vers_dft")

pkg_info="Tk is a graphical user interface toolkit that takes developing desktop applications to a higher level than conventional approaches."

pkg_desc="Tk is a graphical user interface toolkit that takes developing desktop applications to a higher 
level than conventional approaches. Tk is the standard GUI not only for Tcl, but for many other 
dynamic languages, and can produce rich, native applications that run unchanged across Windows, 
Mac OS X, Linux and more."

pkg_opts="configure force-bootstrap force-serial-build"
pkg_uses="tcl/$pkg_vers_dft"
pkg_reqs="$pkg_uses"

pkg_cflags=""
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/languages/tcl/$pkg_vers_dft/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/languages/tcl/$pkg_vers_dft/generic"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/languages/tcl/$pkg_vers_dft/unix"

pkg_ldflags=""
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/languages/tcl/$pkg_vers_dft/lib"

pkg_cfg="--enable-64bit"
pkg_cfg="$pkg_cfg --with-tcl=$BLDR_LOCAL_PATH/languages/tcl/$pkg_vers_dft/lib"

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cfg="$pkg_cfg --disable-framework"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/languages/tcl/$pkg_vers_dft/macosx"
     pkg_cfg_path="unix"
else
     pkg_cfg_path="unix"
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="tk$pkg_vers-src.tar.gz"
    pkg_urls="http://prdownloads.sourceforge.net/tcl/$pkg_file"

    bldr_register_pkg                \
        --category    "$pkg_ctry"    \
        --name        "$pkg_name"    \
        --version     "$pkg_vers"    \
        --default     "$pkg_vers_dft"\
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

