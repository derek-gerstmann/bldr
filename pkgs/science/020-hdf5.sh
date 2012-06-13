#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="hdf5"
pkg_vers="1.8.9"

pkg_info="HDF5 is a unique technology suite that makes possible the management of extremely large and complex data collections."

pkg_desc="HDF5 is a unique technology suite that makes possible the management of extremely large and complex data collections.

The HDF5 technology suite includes:

* A versatile data model that can represent very complex data objects and a wide variety of metadata.
* A completely portable file format with no limit on the number or size of data objects in the collection.
* A software library that runs on a range of computational platforms, from laptops to massively parallel systems, and implements a high-level API with C, C++, Fortran 90, and Java interfaces.
* A rich set of integrated performance features that allow for access time and storage space optimizations.
* Tools and applications for managing, manipulating, viewing, and analyzing the data in the collection."

pkg_file="hdf5-$pkg_vers.tar.gz"
pkg_urls="http://www.hdfgroup.org/ftp/HDF5/current/src/$pkg_file"
pkg_opts="cmake"
pkg_reqs="szip/latest zlib/latest"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DSZIP_INCLUDE_DIR=$BLDR_LOCAL_DIR/science/szip/latest/include"
pkg_cfg="$pkg_cfg:-DSZIP_LIBRARY=$BLDR_LOCAL_DIR/system/szip/latest/lib/libsz.a"

pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=$BLDR_LOCAL_DIR/system/zlib/latest/include"
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=$BLDR_LOCAL_DIR/system/zlib/latest/lib/libz.a"

pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_ZLIB=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_Z_LIB_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_ZLIB_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_SZIP_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_BUILD_HL_LIB=ON"
pkg_cfg="$pkg_cfg:-DHDF5_DISABLE_COMPILER_WARNINGS=ON"
pkg_cfg="$pkg_cfg:-DHDF5_DISABLE_COMPILER_WARNINGS=ON"
pkg_cfg="$pkg_cfg -DCMAKE_CXX_FLAGS='-I$BLDR_LOCAL_DIR/science/szip/latest/include -I$BLDR_LOCAL_DIR/science/szip/latest/src'"
pkg_cfg="$pkg_cfg -DCMAKE_CPP_FLAGS='-I$BLDR_LOCAL_DIR/science/szip/latest/include -I$BLDR_LOCAL_DIR/science/szip/latest/src'"
pkg_cfg="$pkg_cfg -DCMAKE_C_FLAGS='-I$BLDR_LOCAL_DIR/science/szip/latest/include -I$BLDR_LOCAL_DIR/science/szip/latest/src'"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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


####################################################################################################

pkg_name="hdf5-parallel"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_PARALLEL=ON"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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

####################################################################################################

pkg_name="hdf5-parallel-16"
pkg_cfg="$pkg_cfg:-DH5_USE_16_API=ON"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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
