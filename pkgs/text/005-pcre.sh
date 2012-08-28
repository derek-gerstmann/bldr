#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="pcre"
pkg_vers="8.31"
pkg_info="The PCRE package contains Perl Compatible Regular Expression libraries."

pkg_desc="The PCRE package contains Perl Compatible Regular Expression libraries. 

These are useful for implementing regular expression pattern matching using the same 
syntax and semantics as Perl 5. "

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="ftp://ftp.csx.cam.ac.uk/pub/software/programming/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest bzip2/latest"
pkg_uses="$pkg_reqs"
pkg_cfg="$pkg_cfg --enable-static"
pkg_cfg="$pkg_cfg --enable-shared"
pkg_cfg="$pkg_cfg --enable-pcregrep-libz"
pkg_cfg="$pkg_cfg --enable-pcregrep-libbz2"
pkg_cfg="$pkg_cfg --enable-utf"
pkg_cfg="$pkg_cfg --enable-unicode-properties"
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags="$pkg_cflags -fPIC"
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
               --config      "$pkg_cfg"


