#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="1.2.76"
pkg_vers_list=("$pkg_vers")
pkg_ctry="databases"
pkg_name="kyoto-cabinet"
pkg_info="Kyoto Cabinet is a library of routines for managing a database."

pkg_desc="Kyoto Cabinet is a library of routines for managing a database. 

The database is a simple data file containing records, each is a pair of a key and a value. 

Every key and value is serial bytes with variable length. Both binary data and character 
string can be used as a key and a value. Each key must be unique within a database. There 
is neither concept of data tables nor data types. Records are organized in hash table or B+ tree.

Kyoto Cabinet runs very fast. For example, elapsed time to store one million records is 0.9
seconds for hash database, and 1.1 seconds for B+ tree database. Moreover, the size of database 
is very small. For example, overhead for a record is 16 bytes for hash database, and 4 bytes for 
B+ tree database. Furthermore, scalability of Kyoto Cabinet is great. The database size can be 
up to 8EB (9.22e18 bytes).

Kyoto Cabinet is written in the C++ language, and provided as API of C++, C, Java, Python, 
Ruby, Perl, and Lua. Kyoto Cabinet is available on platforms which have API conforming to 
C++03 with the TR1 library extensions. Kyoto Cabinet is a free software licensed under 
the GNU General Public License. On the other hand, a commercial license is also provided. 

If you use Kyoto Cabinet within a proprietary software, the commercial license is required."

pkg_reqs=""
pkg_uses="tar/latest"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in "${pkg_ver_list[@]}"
do
     pkg_file="kyotocabinet-$pkg_vers.tar.gz"
     pkg_opts="configure -MPREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
     pkg_urls="http://fallabs.com/kyotocabinet/pkg/$pkg_file"

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


