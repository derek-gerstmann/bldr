#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="tokyo-tyrant"

pkg_default="1.1.41"
pkg_variants=("1.1.41")

pkg_info="Tokyo Tyrant is a package of network interface to the DBM called Tokyo Cabinet. "

pkg_desc="Tokyo Tyrant is a package of network interface to the DBM called Tokyo Cabinet. 
Though the DBM has high performance, you might bother in case that multiple processes 
share the same database, or remote processes access the database. Thus, Tokyo Tyrant is 
provided for concurrent and remote connections to Tokyo Cabinet. It is composed of the 
server process managing a database and its access library for client applications.

Tokyo Tyrant is written in the C language, and provided as API of C, Perl, and Ruby. 
Tokyo Tyrant is available on platforms which have API conforming to C99 and POSIX. 
Tokyo Tyrant is a free software licensed under the GNU Lesser General Public License."

cfg_opts="configure enable-static enable-shared"
pkg_reqs="tokyo-cabinet lua zlib bzip2 lzo "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg+="--enable-lua "
pkg_cfg+="--with-lua=\"$BLDR_LUA_BASE_PATH\" "
pkg_cfg+="--with-tc=\"$BLDR_TOKYO_CABINET_BASE_PATH\" "
pkg_cfg_path=""

pkg_cflags=""
pkg_ldflags="-lz -lbz2 -llua "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="tokyotyrant-$pkg_vers.tar.gz"
    pkg_opts="$cfg_opts -MPREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    pkg_urls="http://fallabs.com/tokyotyrant/$pkg_file"

    bldr_register_pkg                 \
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


