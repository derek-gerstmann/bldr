#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="grep"

pkg_info="GNU GREP searches input files for lines containing a match to a given regular expression pattern list."

pkg_desc="GNU GREP searches input files for lines containing a match to a given pattern list. 
When it finds a match in a line, it copies the line to standard output (by default), or 
produces whatever other sort of output you have requested with options.

Though grep expects to do the matching on text, it has no limits on input line length other 
than available memory, and it can match arbitrary characters within a line. If the final 
byte of an input file is not a newline, grep silently supplies one. Since newline is also 
a separator for the list of patterns, there is no way to match newline characters in a text."

pkg_vers_dft="2.13"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure force-static"
pkg_uses="coreutils"
pkg_reqs="coreutils"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://fossies.org/unix/misc/$pkg_file"

     bldr_register_pkg                \
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
