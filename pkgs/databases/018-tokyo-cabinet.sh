#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="tokyo-cabinet"

pkg_default="1.4.48"
pkg_variants=("1.4.48")

pkg_info="Tokyo Cabinet is a library of routines for managing a database."

pkg_desc="Kyoto Cabinet is a library of routines for managing a database. 

The database is a simple data file containing records, each is a pair of a key 
and a value. Every key and value is serial bytes with variable length. Both binary 
data and character string can be used as a key and a value. There is neither concept 
of data tables nor data types. Records are organized in hash table, B+ tree, or fixed-length array.

Tokyo Cabinet is developed as the successor of GDBM and QDBM on the following purposes. 
They are achieved and Tokyo Cabinet replaces conventional DBM products.

- improves space efficiency : smaller size of database file.
- improves time efficiency : faster processing speed.
- improves parallelism : higher performance in multi-thread environment.
- improves usability : simplified API.
- improves robustness : database file is not corrupted even under catastrophic situation.
- supports 64-bit architecture : enormous memory space and database file are available.

Tokyo Cabinet is written in the C language, and provided as API of C, Perl, Ruby, Java, and Lua. Tokyo Cabinet is available on platforms which have API conforming to C99 and POSIX. 
Tokyo Cabinet is a free software licensed under the GNU Lesser General Public License."

tc_opts="configure enable-static enable-shared"

pkg_reqs="tar zlib"
pkg_uses="tar zlib"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="tokyocabinet-$pkg_vers.tar.gz"
     pkg_urls="http://fallabs.com/tokyocabinet/$pkg_file"
     pkg_opts="$tc_opts -MPREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

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

