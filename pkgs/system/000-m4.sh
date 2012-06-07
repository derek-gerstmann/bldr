#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="m4"
pkg_vers="1.4.16"

pkg_info="GNU M4 is an implementation of the traditional Unix macro processor. "

pkg_desc="GNU M4 is an implementation of the traditional Unix macro processor. 
It is mostly SVR4 compatible although it has some extensions (for example, handling 
more than 9 positional parameters to macros). GNU M4 also has built-in functions 
for including files, running shell commands, doing arithmetic, etc.

GNU M4 is a macro processor in the sense that it copies its input to the output 
expanding macros as it goes. Macros are either builtin or user-defined and can 
take any number of arguments. Besides just doing macro expansion, m4 has builtin 
functions for including named files, running UNIX commands, doing integer 
arithmetic, manipulating text in various ways, recursion etc... 

M4 can be used either as a front-end to a compiler or as a macro processor in its own right.

One of the biggest users of GNU M4 is the GNU Autoconf project."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/m4/$pkg_file"
pkg_reqs=0
pkg_opts="configure:keep"
pkg_cflags=0
pkg_ldflags=0
pkg_cfg="--disable-shared --enable-static"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg "$pkg_name"    \
               "$pkg_vers"    \
               "$pkg_info"    \
               "$pkg_desc"    \
               "$pkg_file"    \
               "$pkg_urls"    \
               "$pkg_reqs"    \
               "$pkg_opts"    \
               "$pkg_cflags"  \
               "$pkg_ldflags" \
               "$pkg_cfg"


