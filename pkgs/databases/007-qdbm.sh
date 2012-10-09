#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="qdbm"

pkg_default="1.8.78"
pkg_variants=("1.8.78")

pkg_info="QDBM is a library of routines for managing a database."

pkg_desc="QDBM is a library of routines for managing a database. The database is a simple 
data file containing records, each is a pair of a key and a value. Every key and value is 
serial bytes with variable length. Both binary data and character string can be used as a 
key and a value. There is neither concept of data tables nor data types. Records are organized 
in hash table or B+ tree.

As for database of hash table, each key must be unique within a database, so it is impossible 
to store two or more records with a key overlaps. The following access methods are provided 
to the database: storing a record with a key and a value, deleting a record by a key, retrieving 
a record by a key. Moreover, traversal access to every key are provided, although the order is 
arbitrary. These access methods are similar to ones of DBM (or its followers: NDBM and GDBM) 
library defined in the UNIX standard. QDBM is an alternative for DBM because of its higher performance.

As for database of B+ tree, records whose keys are duplicated can be stored. Access methods of 
storing, deleting, and retrieving are provided as with the database of hash table. Records are 
stored in order by a comparing function assigned by a user. It is possible to access each record 
with the cursor in ascending or descending order. According to this mechanism, forward matching 
search for strings and range search for integers are realized. Moreover, transaction is available 
in database of B+ tree.

QDBM is written in C, and provided as APIs of C, C++, Java, Perl, and Ruby. QDBM is available on 
platforms which have API conforming to POSIX. QDBM is a free software licensed under the GNU Lesser 
General Public License."

pkg_opts="configure enable-static "
if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_opts+="use-make-build-target=mac "
    pkg_opts+="use-make-install-target=install-mac "
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_opts+="enable-shared "
fi

pkg_reqs="tar zlib bzip2 lzo libiconv"
pkg_uses="tar zlib bzip2 lzo libiconv"

pkg_cflags=""
pkg_ldflags="-lz -bz2 "

pkg_cfg="--enable-zlib "
pkg_cfg+="--enable-lzo "
pkg_cfg+="--enable-bzip "         
pkg_cfg+="--enable-iconv "
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://fallabs.com/qdbm/$pkg_file"

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

