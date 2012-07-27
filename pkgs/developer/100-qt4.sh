#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="qt"
pkg_vers="4.8.2"
pkg_info="Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language."

pkg_desc="Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language"

pkg_file="$pkg_name-everywhere-opensource-src-$pkg_vers.tar.gz"
pkg_urls="http://releases.qt-project.org/qt4/source/$pkg_file"
pkg_opts="configure disable-xcode-cflags disable-xcode-ldflags config-agree-to-prompt"
pkg_reqs=""
pkg_uses="tar/latest m4/latest autoconf/latest automake/latest $pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-opensource -release -continue -silent"

if [ $BLDR_SYSTEM_IS_OSX -eq 1 ]
then
     pkg_cfg="$pkg_cfg -arch $BLDR_OSX_ARCHITECTURES" 
     pkg_cfg="$pkg_cfg -no-framework -static"
fi

pkg_cfg="$pkg_cfg -no-cups"
pkg_cfg="$pkg_cfg -no-javascript-jit"
pkg_cfg="$pkg_cfg -no-audio-backend"
pkg_cfg="$pkg_cfg -no-svg"
pkg_cfg="$pkg_cfg -no-openssl"
pkg_cfg="$pkg_cfg -no-qt3support"
pkg_cfg="$pkg_cfg -no-webkit"
pkg_cfg="$pkg_cfg -no-sql-sqlite"
pkg_cfg="$pkg_cfg -qt-libjpeg"
pkg_cfg="$pkg_cfg -make libs"
pkg_cfg="$pkg_cfg -make tools"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "developer"    \
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


