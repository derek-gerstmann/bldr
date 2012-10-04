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
pkg_info="Ruby is a dynamic, open source programming language with a focus on simplicity and productivity."

pkg_desc="Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.

It has an elegant syntax that is natural to read and easy to write."

pkg_vers_dft="1.9.3-p194"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure use-build-makefile=GNUmakefile"
pkg_reqs="openssl tcl tk gdbm ncurses libyaml"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftp.ruby-lang.org/pub/ruby/1.9/$pkg_file"

     bldr_register_pkg                 \
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
