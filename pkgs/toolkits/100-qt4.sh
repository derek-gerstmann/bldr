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
pkg_vers="4.8.2"
pkg_info="Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language."

pkg_desc="Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language"

pkg_file="$pkg_name-everywhere-opensource-src-$pkg_vers.tar.gz"
pkg_urls="http://releases.qt-project.org/qt4/source/$pkg_file"
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

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################


pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-opensource -release -continue -silent -confirm-license -fast"

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     pkg_cfg="$pkg_cfg -arch $BLDR_OSX_ARCHITECTURES -no-webkit" 
fi

pkg_cfg="$pkg_cfg -make libs"
pkg_cfg="$pkg_cfg -make tools"
pkg_cfg="$pkg_cfg -no-libmng"
pkg_cfg="$pkg_cfg -system-libjpeg"
pkg_cfg="$pkg_cfg -system-libtiff"
pkg_cfg="$pkg_cfg -system-libpng"
pkg_cfg="$pkg_cfg -system-zlib"
pkg_cfg="$pkg_cfg -openssl-linked"
pkg_cfg="$pkg_cfg -I \"$BLDR_ZLIB_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_FLEX_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_OPENSSL_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBICU_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBICONV_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBEDIT_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBTIFF_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBJPEG_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBPNG_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_ZLIB_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_BISON_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_FLEX_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_GPERF_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_OPENSSL_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBICU_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBICONV_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBEDIT_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBTIFF_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBJPEG_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBPNG_LIB_PATH\""
qt4_cfg="$pkg_cfg"

####################################################################################################
# build and install pkg as local module
####################################################################################################

pkg_name="qt-static"
pkg_cfg="$qt4_cfg -no-framework -static"
bldr_build_pkg                    \
     --category    "$pkg_ctry"    \
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

pkg_name="qt"
pkg_cfg="$qt4_cfg"
bldr_build_pkg                    \
     --category    "$pkg_ctry"    \
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

