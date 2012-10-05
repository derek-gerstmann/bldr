#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="languages"
pkg_name="python"

pkg_default="2.7.3"
pkg_variants=("2.7.3" "3.2.3")

pkg_info="Python is a programming language that lets you work more quickly and integrate your systems more effectively."

pkg_desc="Python is a programming language that lets you work more quickly and 
integrate your systems more effectively. You can learn to use Python and see 
almost immediate gains in productivity and lower maintenance costs.

Python runs on Windows, Linux/Unix, Mac OS X, and has been ported to the 
Java and .NET virtual machines.

Python is free to use, even for commercial products, because of its 
OSI-approved open source license."

pkg_opts="configure"
pkg_reqs="zlib bzip2"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/compression/zlib/default/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/compression/zlib/default/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/bzip2/default/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/bzip2/default/lib"

pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="Python-$pkg_vers.tar.bz2"
    pkg_urls="http://www.python.org/ftp/python/$pkg_vers/$pkg_file"

    bldr_register_pkg                  \
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

