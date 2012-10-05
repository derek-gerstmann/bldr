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

pkg_default="1.0.6"
pkg_variants=("1.0.6")

pkg_info="BZIP2 is a freely available, patent free (see below), high-quality data compressor."

pkg_desc="BZIP2 is a freely available, patent free (see below), high-quality data compressor. 
It typically compresses files to within 10% to 15% of the best available techniques 
(the PPM family of statistical compressors), whilst being around twice as fast at 
compression and six times faster at decompression."

pkg_uses="m4 autoconf automake"
pkg_reqs=""

bz2_opts="configure "
bz2_opts+="skip-bootstrap "
bz2_opts+="migrate-build-headers "
bz2_opts+="migrate-build-bin "

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://www.bzip.org/$pkg_vers/$pkg_file"
     pkg_opts="$bz2_opts -MPREFIX=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers\" "

     if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
     then
          pkg_opts+="use-build-makefile=Makefile-libbz2_so "

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
               --config      "$pkg_cfg"
                         
     fi

     pkg_opts="$bz2_opts -MPREFIX=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers\" "

     if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
     then
          pkg_opts+="migrate-skip-libs "
          pkg_opts+="keep-existing-install "
          pkg_opts+="force-rebuild "
     fi

     bldr_register_pkg                  \
          --category    "$pkg_ctry"     \
          --name        "$pkg_name"     \
          --version     "$pkg_vers"     \
          --default     "$pkg_default"  \
          --info        "$pkg_info"     \
          --description "$pkg_desc"     \
          --file        "$pkg_file"     \
          --url         "$pkg_urls"     \
          --uses        "$pkg_uses"     \
          --requires    "$pkg_reqs"     \
          --options     "$pkg_opts"     \
          --cflags      "$pkg_cflags"   \
          --ldflags     "$pkg_ldflags"  \
          --config      "$pkg_cfg"
done

####################################################################################################

