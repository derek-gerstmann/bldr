#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="sed"

pkg_default="4.2.1"
pkg_variants=("4.2.1")

pkg_info="GNU SED is a stream editor used to perform basic text transformations on an input stream (a file or input from a pipeline). "

pkg_desc="GNU SED is a stream editor used to perform basic text transformations on 
an input stream (a file or input from a pipeline). 

While in some ways similar to an editor which permits scripted edits (such as ed), 
sed works by making only one pass over the input(s), and is consequently more efficient. 

But it is sed's ability to filter text in a pipeline which particularly distinguishes it 
from other types of editors."

pkg_opts="configure force-static"
pkg_uses="coreutils"
pkg_reqs="coreutils"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://ftp.gnu.org/gnu/$pkg_name/$pkg_file"

     bldr_register_pkg                \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_default" \
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
