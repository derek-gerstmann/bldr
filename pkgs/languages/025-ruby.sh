#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="languages"
pkg_name="ruby"
pkg_vers="1.9.3-p194"
pkg_info="Ruby is a dynamic, open source programming language with a focus on simplicity and productivity."

pkg_desc="Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.

It has an elegant syntax that is natural to read and easy to write."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.ruby-lang.org/pub/ruby/1.9/$pkg_file"
pkg_opts="configure use-build-makefile=GNUmakefile"
pkg_reqs="openssl/latest tcl/latest tk/latest gdbm/latest ncurses/latest libyaml/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
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


