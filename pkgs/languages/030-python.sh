#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ver_list="2.7.3 3.2.3"
pkg_ctry="languages"
pkg_name="python"

pkg_info="Python is a programming language that lets you work more quickly and integrate your systems more effectively."

pkg_desc="Python is a programming language that lets you work more quickly and 
integrate your systems more effectively. You can learn to use Python and see 
almost immediate gains in productivity and lower maintenance costs.

Python runs on Windows, Linux/Unix, Mac OS X, and has been ported to the 
Java and .NET virtual machines.

Python is free to use, even for commercial products, because of its 
OSI-approved open source license."

pkg_file="Python-$pkg_vers.tar.bz2"
pkg_urls="http://www.python.org/ftp/python/$pkg_vers/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest bzip2/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/bzip2/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/bzip2/latest/lib"

pkg_cfg=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_ver_list}
do
    pkg_file="Python-$pkg_vers.tar.bz2"
    pkg_urls="http://www.python.org/ftp/python/$pkg_vers/$pkg_file"

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
done
