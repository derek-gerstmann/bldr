#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="gettext"
pkg_vers="0.18.1.1"
pkg_info="GNU gettext is designed to minimize the impact of internationalization on program sources."

pkg_desc="GNU gettext is designed to minimize the impact of internationalization on program sources, 
keeping this impact as small and hardly noticeable as possible. Internationalization has better 
chances of succeeding if it is very light weighted, or at least, appear to be so, when looking at 
program sources.

The Translation Project also uses the GNU gettext distribution as a vehicle for documenting its 
structure and methods. This goes beyond the strict technicalities of documenting the GNU gettext 
proper. By so doing, translators will find in a single place, as far as possible, all they need 
to know for properly doing their translating work. Also, this supplemental documentation might 
also help programmers, and even curious users, in understanding how GNU gettext is related to the 
remainder of the Translation Project, and consequently, have a glimpse at the big picture."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/pub/gnu/gettext/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest"
#" libiconv/latest libicu/latest libxml2/latest"
pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest $pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
#pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/libiconv/latest/include"
#pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/libicu/latest/include"

pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"
#pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/libiconv/latest/lib"
#pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/libicu/latest/lib"

pkg_cfg="--with-gnu-ld --without-emacs"
pkg_cfg="$pkg_cfg --with-included-glib"
pkg_cfg="$pkg_cfg --with-included-libunistring"
pkg_cfg="$pkg_cfg --with-included-libcroco"
# pkg_cfg="$pkg_cfg --with-libiconv-prefix=$BLDR_LOCAL_PATH/internal/libiconv/latest"
# pkg_cfg="$pkg_cfg --with-libxml2-prefix=$BLDR_LOCAL_PATH/internal/libxml2/latest"

pkg_patch=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "internal"     \
               --name        "$pkg_name"    \
               --version     "$pkg_vers"    \
               --info        "$pkg_info"    \
               --description "$pkg_desc"    \
               --file        "$pkg_file"    \
               --url         "$pkg_urls"    \
               --patch       "$pkg_patch"   \
               --uses        "$pkg_uses"    \
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"


