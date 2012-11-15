#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="cryptography"
pkg_name="cryptopp"

pkg_default="5.6.1"
pkg_variants=("5.6.1")
pkg_distribs=("cryptopp561.zip")

pkg_info="Crypto++ Library is a free C++ class library of cryptographic schemes."

pkg_desc="Crypto++ Library is a free C++ class library of cryptographic schemes."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="coreutils libtool m4 automake autoconf"
pkg_uses="bzip2 tar"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
     bldr_log_split
else
	let pkg_idx=0
	for pkg_vers in ${pkg_variants[@]}
	do
	    pkg_file="${pkg_distribs[$pkg_idx]}"
		pkg_urls="http://www.cryptopp.com/$pkg_file"

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
fi

####################################################################################################


