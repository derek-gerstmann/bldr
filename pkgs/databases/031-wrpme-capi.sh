#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="trunk"
pkg_ctry="databases"
pkg_name="wrpme-capi"
pkg_info="WRPME CAPI provides a ANSI-C99 API to the WRPME server."

pkg_desc="WRPME CAPI provides a ANSI-C99 API to the WRPME server.

WRPME is a key / value store. It is fast and scalable. 

It handles concurrent accesses very well and is designed to manage large amounts of data at high-frequency.

WRPME is limitless. In other words, we didn't put any limit in WRPME. 

If your computer has got enough memory and enough disk space, WRPME can handle it.

One can label WRPME as a NoSQL database but we prefer the term post-modern database.

Where would you want to use WRPME? Here are few use cases:

* High-frequency trading market data store
* Heavy traffic web cache
* Multiplayer game dynamic elements depot
* Distributed computing common data store
* Relational database cache"

pkg_opts="skip-compile skip-install migrate-build-tree"
pkg_reqs="wrpme-server/latest"
pkg_uses="tar/latest"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path=""
pkg_file="$pkg_name-master-linux-64bit.tgz"
pkg_urls="http://www.wrpme.com/builds/$pkg_file"

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     bldr_log_status "$pkg_name $pkg_vers is not available on OSX right now.  Skipping ..."
     bldr_log_split
else
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
fi

