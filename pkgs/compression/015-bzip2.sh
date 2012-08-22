#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compression"
pkg_name="bzip2"
pkg_vers="1.0.6"
pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.bzip.org/1.0.6/$pkg_file"

pkg_info="BZIP2 is a freely available, patent free (see below), high-quality data compressor."

pkg_desc="BZIP2 is a freely available, patent free (see below), high-quality data compressor. 
It typically compresses files to within 10% to 15% of the best available techniques 
(the PPM family of statistical compressors), whilst being around twice as fast at 
compression and six times faster at decompression."

pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs="$pkg_uses"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

pkg_opts="configure skip-bootstrap migrate-build-headers migrate-build-bin"
pkg_opts="$pkg_opts -MPREFIX=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers\""
bz2_opts="$pkg_opts"

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_opts="$bz2_opts use-build-makefile=Makefile-libbz2_so"

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

####################################################################################################
# build and install pkg as local module
####################################################################################################

pkg_opts="$bz2_opts"

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
