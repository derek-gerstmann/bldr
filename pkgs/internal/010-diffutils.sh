#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="diffutils"
pkg_vers="3.2"

pkg_info="GNU Diffutils is a package of several programs related to finding differences between files."

pkg_desc="GNU Diffutils is a package of several programs related to finding differences between files.

Computer users often find occasion to ask how two files differ. Perhaps one file is a newer version 
of the other file. Or maybe the two files started out as identical copies but were changed by 
different people.

You can use the diff command to show differences between two files, or each corresponding file 
in two directories. diff outputs differences between files line by line in any of several formats, 
selectable by command line options. This set of differences is often called a ‘diff’ or ‘patch’. 
For files that are identical, diff normally produces no output; for binary (non-text) files, 
diff normally reports only that they are different.

You can use the cmp command to show the offsets and line numbers where two files differ. cmp 
can also show all the characters that differ between the two files, side by side.

You can use the diff3 command to show differences among three files. When two people have made 
independent changes to a common original, diff3 can report the differences between the original 
and the two changed versions, and can produce a merged file that contains both persons' changes 
together with warnings about conflicts.

You can use the sdiff command to merge two files interactively."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/$pkg_name/$pkg_file"
pkg_opts="configure force-static"
pkg_reqs="coreutils/latest"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "$pkg_ctry"     \
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


