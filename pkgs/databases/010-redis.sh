#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers_list="2.4.16 2.6.0-rc6"
pkg_ctry="databases"
pkg_name="redis"
pkg_info="Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets."

pkg_desc="Redis is an open source, advanced key-value store. It is often referred to as 
a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.

You can run atomic operations on these types, like appending to a string; incrementing 
the value in a hash; pushing to a list; computing set intersection, union and difference; 
or getting the member with highest ranking in a sorted set.

In order to achieve its outstanding performance, Redis works with an in-memory dataset. 
Depending on your use case, you can persist it either by dumping the dataset to disk every 
once in a while, or by appending each command to a log.

Redis also supports trivial-to-setup master-slave replication, with very fast non-blocking 
first synchronization, auto-reconnection on net split and so forth.

Other features include a simple check-and-set mechanism, pub/sub and configuration settings 
to make Redis behave like a cache.

You can use Redis from most programming languages out there.

Redis is written in ANSI C and works in most POSIX systems like Linux, *BSD, OS X without 
external dependencies. Linux and OSX are the two operating systems where Redis is developed 
and more tested, and we recommend using Linux for deploying. Redis may work in Solaris-derived 
systems like SmartOS, but the support is best effort. There is no official support for Windows 
builds, although you may have some options."

pkg_opts="configure migrate-build-binaries"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_ver_list}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://redis.googlecode.com/files/$pkg_file"

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


