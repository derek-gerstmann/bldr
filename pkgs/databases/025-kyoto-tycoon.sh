#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers_list=("0.9.56")
pkg_ctry="databases"
pkg_name="kyoto-tycoon"
pkg_info="Kyoto Tycoon is a lightweight database server."

pkg_desc="Kyoto Tycoon is a lightweight database server with auto expiration 
mechanism, which is useful to handle cache data and persistent data of various 
applications. Kyoto Tycoon is also a package of network interface to the DBM 
called Kyoto Cabinet. Though the DBM has high performance and high concurrency, 
you might bother in case that multiple processes share the same database, or remote
processes access the database. Thus, Kyoto Tycoon is provided for concurrent and 
remote connections to Kyoto Cabinet. Kyoto Tycoon is composed of the server process 
managing multiple databases and its access library for client applications.

The network protocol between the server and clients is HTTP so that you can write 
client applications and client libraries in almost all popular languages. Both of 
RESTful-style interface by the GET, HEAD, PUT, DELETE methods and RPC-style inteface 
by the POST method are supported. The server can handle more than 10 thousand 
connections at the same time because it uses modern I/O event notification facilities 
such as 'epoll' and 'kqueue' of underlying systems. The server supports high 
availability mechanisms, which are hot backup, update logging, and asynchronous 
replication. The server can embed Lua, a lightweight script language so that you 
can define arbitrary operations of the database.

The server program of Kyoto Tycoon is written in the C++ language. It is available 
on platforms which have API conforming to C++03 with the TR1 library extensions. 
Kyoto Tycoon is a free software licensed under the GNU General Public License."

pkg_reqs="kyoto-cabinet/latest lua/latest"
pkg_uses="$pkg_reqs"
pkg_cflags="-I$BLDR_LOCAL_PATH/languages/lua/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/languages/lua/latest/lib"
pkg_cfg=""
pkg_cfg="$pkg_cfg --enable-lua"
pkg_cfg="$pkg_cfg --with-lua=$BLDR_LOCAL_PATH/languages/lua/latest"
pkg_cfg="$pkg_cfg --with-kc=$BLDR_LOCAL_PATH/databases/kyoto-cabinet/latest"
pkg_cfg_path=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list}
do
     pkg_file="kyototycoon-$pkg_vers.tar.gz"
     pkg_opts="configure -MPREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
     pkg_urls="http://fallabs.com/kyototycoon/pkg/$pkg_file"
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


