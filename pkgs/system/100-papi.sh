#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="system"
pkg_name="papi"
pkg_vers="4.4.0"

pkg_info="The Performance API (PAPI) project specifies a standard application programming interface (API) for accessing hardware performance counters available on most modern microprocessors."

pkg_desc="The Performance API (PAPI) project specifies a standard application programming interface 
(API) for accessing hardware performance counters available on most modern microprocessors. 

These counters exist as a small set of registers that count Events, occurrences of specific signals 
related to the processor's function. Monitoring these events facilitates correlation between the 
structure of source/object code and the efficiency of the mapping of that code to the underlying 
architecture. This correlation has a variety of uses in performance analysis including hand tuning, 
compiler optimization, debugging, benchmarking, monitoring and performance modeling. In addition, 
it is hoped that this information will prove useful in the development of new compilation technology 
as well as in steering architectural development towards alleviating commonly occurring bottlenecks 
in high performance computing."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://icl.cs.utk.edu/projects/papi/downloads/$pkg_file"
pkg_opts="configure force-serial-build"
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path="src"

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     pkg_cfg="$pkg_cfg --with-OS=darwin"
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_path"

