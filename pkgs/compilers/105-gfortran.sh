#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="4.7.1"
pkg_ver_list="4.7.1"

pkg_ctry="compilers"
pkg_name="gfortran"
pkg_info="The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, Ada, and Go, as well as libraries for these languages (libstdc++, libgcj,...)."

pkg_desc="The GNU Compiler Collection includes front ends for C, C++, Objective-C, 
Fortran, Java, Ada, and Go, as well as libraries for these languages (libstdc++, libgcj,...). 

GCC was originally written as the compiler for the GNU operating system. The GNU system was 
developed to be 100% free software, free in the sense that it respects the user's freedom.

We strive to provide regular, high quality releases, which we want to work well on a variety 
of native and cross targets (including GNU/Linux), and encourage everyone to contribute changes 
or help testing GCC. Our sources are readily and freely available via SVN and weekly snapshots.

Major decisions about GCC are made by the steering committee, guided by the mission statement."

pkg_file="gcc-$pkg_vers.tar.bz2"
pkg_urls="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$pkg_vers/$pkg_file"
pkg_opts="configure skip-xcode-config"

pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs gmp/latest"
pkg_reqs="$pkg_reqs ppl/latest"
pkg_reqs="$pkg_reqs mpfr/latest"
pkg_reqs="$pkg_reqs mpc/latest"
pkg_reqs="$pkg_reqs isl/latest"
pkg_reqs="$pkg_reqs osl/latest"
pkg_reqs="$pkg_reqs cloog/latest"
pkg_reqs="$pkg_reqs perl/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--disable-bootstrap"
pkg_cfg="$pkg_cfg --enable-checking=release"
pkg_cfg="$pkg_cfg --enable-languages=fortran"
pkg_cfg="$pkg_cfg --with-gmp=\"$BLDR_GMP_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-isl=\"$BLDR_ISL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-osl=\"$BLDR_OSL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-mpfr=\"$BLDR_MPFR_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-mpc=\"$BLDR_MPC_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-ppl=\"$BLDR_PPL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-cloog=\"$BLDR_CLOOG_BASE_PATH\""
pkg_cfg="$pkg_cfg --enable-cloog-backend=isl"
pkg_cfg="$pkg_cfg --disable-ppl-version-check"
pkg_cfg="$pkg_cfg --disable-cloog-version-check"
pkg_cfg="$pkg_cfg --with-system-zlib"
pkg_cfg="$pkg_cfg --enable-stage1-checking"
pkg_cfg="$pkg_cfg --disable-nls"
pkg_cfg="$pkg_cfg --disable-multilib"
pkg_cfg="$pkg_cfg --enable-lto"

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_ver_list}
do
    pkg_file="gcc-$pkg_vers.tar.bz2"
    pkg_urls="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$pkg_vers/$pkg_file"
    bldr_build_pkg                   \
        --category    "$pkg_ctry"    \
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
