#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="bison"
pkg_vers="2.6.1"
pkg_info="Bison is a tool for generating parsers (eg for building custom compilers)."

pkg_desc="Bison is a general-purpose parser generator that converts an annotated 
context-free grammar into a deterministic LR or generalized LR (GLR) parser 
employing LALR(1) parser tables. As an experimental feature, Bison can also 
generate IELR(1) or canonical LR(1) parser tables. Once you are proficient 
with Bison, you can use it to develop a wide range of language parsers, from 
those used in simple desk calculators to complex programming languages.

Bison is upward compatible with Yacc: all properly-written Yacc grammars 
ought to work with Bison with no change. Anyone familiar with Yacc should 
be able to use Bison with little trouble. You need to be fluent in C or C++ 
programming in order to use Bison. Java is also supported as an experimental 
feature. "

pkg_file="$pkg_name-$pkg_vers.tar.xz"
pkg_urls="http://ftp.gnu.org/gnu/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs="coreutils/latest gettext/latest libiconv/latest"
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

pkg_cfg=""
pkg_cfg="$pkg_cfg --with-libiconv-prefix=\"$BLDR_LIBICONV_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-libintl-prefix=\"$BLDR_GETTEXT_BASE_PATH\""

pkg_patch=""

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


