#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="gcc"

pkg_default="4.7.2"
pkg_variants=("4.6.3" "4.7.2")

pkg_info="The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, Ada, and Go, as well as libraries for these languages (libstdc++, libgcj,...)."

pkg_desc="The GNU Compiler Collection includes front ends for C, C++, Objective-C, 
Fortran, Java, Ada, and Go, as well as libraries for these languages (libstdc++, libgcj,...). 

GCC was originally written as the compiler for the GNU operating system. The GNU system was 
developed to be 100% free software, free in the sense that it respects the user's freedom.

We strive to provide regular, high quality releases, which we want to work well on a variety 
of native and cross targets (including GNU/Linux), and encourage everyone to contribute changes 
or help testing GCC. Our sources are readily and freely available via SVN and weekly snapshots.

Major decisions about GCC are made by the steering committee, guided by the mission statement."

pkg_opts="configure skip-xcode-config"

pkg_reqs="zlib "
pkg_reqs+="gmp "
pkg_reqs+="ppl "
pkg_reqs+="mpfr "
pkg_reqs+="mpc "
pkg_reqs+="isl "
pkg_reqs+="osl "
pkg_reqs+="cloog "
pkg_reqs+="perl "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--disable-bootstrap "
pkg_cfg+="--enable-checking=release "
pkg_cfg+="--enable-languages=c,c++,objc,obj-c++,lto "
pkg_cfg+="--with-gmp=\"$BLDR_GMP_BASE_PATH\" "
pkg_cfg+="--with-isl=\"$BLDR_ISL_BASE_PATH\" "
pkg_cfg+="--with-osl=\"$BLDR_OSL_BASE_PATH\" "
pkg_cfg+="--with-mpfr=\"$BLDR_MPFR_BASE_PATH\" "
pkg_cfg+="--with-mpc=\"$BLDR_MPC_BASE_PATH\" "
pkg_cfg+="--with-ppl=\"$BLDR_PPL_BASE_PATH\" "
pkg_cfg+="--with-cloog=\"$BLDR_CLOOG_BASE_PATH\" "
pkg_cfg+="--enable-cloog-backend=isl "
pkg_cfg+="--disable-ppl-version-check "
pkg_cfg+="--disable-cloog-version-check "
pkg_cfg+="--with-system-zlib "
pkg_cfg+="--enable-stage1-checking "
pkg_cfg+="--disable-nls "
pkg_cfg+="--disable-multilib "
pkg_cfg+="--enable-lto "

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants}
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/$pkg_name-$pkg_vers/$pkg_file"

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
