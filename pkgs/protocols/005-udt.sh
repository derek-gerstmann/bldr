#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="udt"

pkg_default="4.10"
pkg_variants=("4.10")

pkg_info="UDT is a high performance data transfer protocol - UDP-based data transfer protocol. "

pkg_desc="UDT is a high performance data transfer protocol - UDP-based data transfer protocol. 

It was designed for data intensive applications over high speed wide area networks, to overcome 
the efficiency and fairness problems of TCP. As its name indicates, UDT is built on top of UDP 
and it provides both reliable data streaming and messaging services."

pkg_opts="configure force-serial-build skip-install migrate-build-bin migrate-build-headers "
if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_opts+="-Mos=OSX "
fi
if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_opts+="-Mos=LINUX "
fi
if [[ $BLDR_SYSTEM_IS_64BIT == true ]]; then
    pkg_opts+="-March=AMD64 "
else
    pkg_opts+="-March=IA32 "    
fi

pkg_reqs=""
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="udt.sdk.$pkg_vers.tar.gz"
    pkg_urls="http://aarnet.dl.sourceforge.net/project/udt/$pkg_name/$pkg_vers/$pkg_file"    
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

    let pkg_idx++
done

####################################################################################################

