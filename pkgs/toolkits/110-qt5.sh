#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="qt"
pkg_vers="5.0.0-beta1"
pkg_info="Qt is a cross-platform application and UI framework for developers using C++ or QML, 
a CSS & JavaScript like language."

pkg_desc="Qt is a cross-platform application and UI framework for developers using C++ or QML, 
a CSS & JavaScript like language"

pkg_file="$pkg_name-everywhere-opensource-src-$pkg_vers.tar.gz"
pkg_urls="http://releases.qt-project.org/qt5.0-beta-snapshots/src_snapshot/$pkg_file"
pkg_opts="configure skip-auto-compile-flags"

pkg_reqs=""
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs bison/latest"
pkg_reqs="$pkg_reqs flex/latest"
pkg_reqs="$pkg_reqs gperf/latest"
pkg_reqs="$pkg_reqs openssl/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libiconv/latest"
pkg_reqs="$pkg_reqs libedit/latest"
pkg_reqs="$pkg_reqs perl/latest"
pkg_reqs="$pkg_reqs python/2.7.3"
pkg_reqs="$pkg_reqs libtiff/latest"
pkg_reqs="$pkg_reqs libjpeg/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_uses="$pkg_reqs"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-opensource -release -continue -silent -confirm-license"

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     pkg_cfg="$pkg_cfg -arch $BLDR_OSX_ARCHITECTURES" 
     pkg_cfg="$pkg_cfg -no-framework -static"
fi

pkg_cfg="$pkg_cfg -qt-libmng"
pkg_cfg="$pkg_cfg -system-libjpeg"
pkg_cfg="$pkg_cfg -system-libtiff"
pkg_cfg="$pkg_cfg -system-libpng"
pkg_cfg="$pkg_cfg -system-zlib"
pkg_cfg="$pkg_cfg -make libs"
pkg_cfg="$pkg_cfg -make tools"

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


