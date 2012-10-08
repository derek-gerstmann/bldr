#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="fastbit"

pkg_default="1.3.2"
pkg_variants=("1.3.2")

pkg_info="FastBit is a minimalistic data warehousing engine designed to test ideas on bitmap indexes."

pkg_desc="FastBit is an open-source data processing library following the spirit of NoSQL movement. 

It offers a set of searching functions supported by compressed bitmap indexes. It treats user 
data in the column-oriented manner similar to well-known database management systems such as 
Sybase IQ, MonetDB, and Vertica. It is designed to accelerate user's data selection tasks without 
imposing undue requirements. In particular, the user data is NOT required to be under the control 
of FastBit software, which allows the user to continue to use their existing data analysis tools."

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-ibis${pkg_vers}.tar.gz"
     pkg_urls="https://codeforge.lbl.gov/frs/download.php/395/$pkg_file"

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
done

####################################################################################################

