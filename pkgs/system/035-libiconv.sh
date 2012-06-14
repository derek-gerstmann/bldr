#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="libiconv"
pkg_vers="1.14"

pkg_info="The GNU libiconv library provides utilities for converting text from/to Unicode via the iconv() method."

pkg_desc="The GNU libiconv library provides utilities for converting text from/to Unicode via the iconv() method.

For historical reasons, international text is often encoded using a language or country dependent 
character encoding. With the advent of the internet and the frequent exchange of text across 
countries - even the viewing of a web page from a foreign country is a 'text exchange' in this 
context -, conversions between these encodings have become important. They have also become a problem, 
because many characters which are present in one encoding are absent in many other encodings. To 
solve this mess, the Unicode encoding has been created. It is a super-encoding of all others and 
is therefore the default encoding for new text formats like XML.

Still, many computers still operate in locale with a traditional (limited) character encoding. 
Some programs, like mailers and web browsers, must be able to convert between a given text encoding 
and the user's encoding. Other programs internally store strings in Unicode, to facilitate internal 
processing, and need to convert between internal string representation (Unicode) and external 
string representation (a traditional encoding) when they are doing I/O. GNU libiconv is a 
conversion library for both kinds of applications. "

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/pub/gnu/libiconv/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest"
pkg_uses="m4/latest autoconf/latest automake/latest $pkg_reqs"
pkg_cfg="--enable-static --enable-shared"
pkg_cflags="-I$BLDR_LOCAL_PATH/system/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/system/zlib/latest/lib"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "system"       \
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


