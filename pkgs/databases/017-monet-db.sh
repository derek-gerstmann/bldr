#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="monet-db"

pkg_default="11.13.3"
pkg_variants=("11.13.3")

pkg_info="MonetDB pioneered column-store solutions for high-performance data warehouses for business intelligence and eScience."

pkg_desc="MonetDB  pioneered column-store solutions for high-performance data warehouses for business 
intelligence and eScience since 1993. It achieves its goal by innovations at all layers of a DBMS, 
e.g. a storage model based on vertical fragmentation, a modern CPU-tuned query execution architecture, 
automatic and adaptive indices, run-time query optimization, and a modular software architecture. 
It is based on the SQL 2003 standard with full support for foreign keys, joins, views, triggers, 
and stored procedures. It is fully ACID compliant and supports a rich spectrum of programming 
interfaces (JDBC, ODBC, PHP, Python, RoR, C/C++, Perl).

MonetDB is distributed both as a source tarball, packages for installation, and binary installers 
on a variety of platforms. The latest release has been tested on Linux (Fedora, RedHat Enterprise 
Linux, Debian, Ubuntu), Gentoo, Mac OS, SUN Solaris, Open Solaris, Windows XP, Windows Sever 
2003, Windows Vista. A regular release schedule ensures the latest functional improvements to reach 
the community quickly.

MonetDB is the focus of database research pushing the technology envelop in many areas. Its three-level 
software stack, comprised of SQL front-end, tactical-optimizers, and columnar abstract-machine kernel, 
provide a flexible environment to customize it many different ways. A rich collection of linked-in 
libraries provide functionality for temporal data types, math routine, strings, and URLs. In-depth 
information on the technical innovations in the design and implementation of MonetDB can be found 
in our science library. 

Last, but not least, the MonetDB system is distributed under the liberal open-source license. It 
allows you to modify and extend it in any way you like and subsequently redistribute it in open 
and close source products. Bug-fixes and functional enhancements to the MonetDB code base are 
highly appreciated."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="MonetDB-$pkg_vers.tar.xz"
     pkg_urls="http://dev.monetdb.org/downloads/sources/Latest/$pkg_file"

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


