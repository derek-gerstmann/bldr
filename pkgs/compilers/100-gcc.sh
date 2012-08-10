#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ver_list="4.6.3 4.7.1"

pkg_ctry="compilers"
pkg_name="gcc"
pkg_info="The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, Ada, and Go, as well as libraries for these languages (libstdc++, libgcj,...)."

pkg_desc="The GNU Compiler Collection includes front ends for C, C++, Objective-C, 
Fortran, Java, Ada, and Go, as well as libraries for these languages (libstdc++, libgcj,...). 

GCC was originally written as the compiler for the GNU operating system. The GNU system was 
developed to be 100% free software, free in the sense that it respects the user's freedom.

We strive to provide regular, high quality releases, which we want to work well on a variety 
of native and cross targets (including GNU/Linux), and encourage everyone to contribute changes 
or help testing GCC. Our sources are readily and freely available via SVN and weekly snapshots.

Major decisions about GCC are made by the steering committee, guided by the mission statement."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/$pkg_name-$pkg_vers/$pkg_file"
pkg_opts="configure disable-xcode-cflags disable-xcode-ldflags"

pkg_reqs="gmp/latest mpfr/latest mpc/latest isl/latest osl/latest cloog/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/compression/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/compression/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/gmp/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/gmp/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/ppl/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/ppl/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/mpfr/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/mpfr/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/mpc/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/mpc/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/numerics/isl/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/numerics/isl/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/compilers/cloog/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/compilers/cloog/latest/lib"

pkg_cfg="--enable-checking=release"
pkg_cfg="$pkg_cfg --enable-languages=c,c++,fortran"
pkg_cfg="$pkg_cfg --with-gmp=$BLDR_LOCAL_PATH/numerics/gmp/latest"
pkg_cfg="$pkg_cfg --with-mpfr=$BLDR_LOCAL_PATH/numerics/mpfr/latest"
pkg_cfg="$pkg_cfg --with-mpc=$BLDR_LOCAL_PATH/numerics/mpc/latest"
pkg_cfg="$pkg_cfg --with-isl=$BLDR_LOCAL_PATH/numerics/isl/latest"
pkg_cfg="$pkg_cfg --with-ppl=$BLDR_LOCAL_PATH/numerics/ppl/latest"
pkg_cfg="$pkg_cfg --with-cloog=$BLDR_LOCAL_PATH/compilers/cloog/latest"
pkg_cfg="$pkg_cfg --with-host-libstdcxx=-lstdc++"
pkg_patch=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_ver_list}
do
     pkg_file="$pkg_name-$pkg_vers.tar.bz2"
     pkg_urls="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/$pkg_name-$pkg_vers/$pkg_file"
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
                    --patch       "$pkg_patch"   \
                    --cflags      "$pkg_cflags"  \
                    --ldflags     "$pkg_ldflags" \
                    --config      "$pkg_cfg"
done
