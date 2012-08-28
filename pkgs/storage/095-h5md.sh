#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="h5md"
pkg_vers="trunk"

pkg_info="The H5MB library is a simple MultiBlock wrapper for HDF5 so that each process can create one or more datasets/group, write some data into it independently."

pkg_desc="The H5MB library is a simple MultiBlock wrapper for HDF5 so that each 
process can create one or more datasets/group, write some data into it 
independently."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="https://hpcforge.org/anonscm/git/libh5mb/libh5mb.git"
pkg_opts="cmake"
pkg_reqs="szip/latest zlib/latest szip/latest openmpi/1.6 phdf5/latest gfortran/latest"
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

pkg_cflags=""
pkg_ldflags=""

####################################################################################################

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DMPI_INCLUDE_PATH=$BLDR_OPENMPI_INCLUDE_PATH"
pkg_cfg="$pkg_cfg:-DMPI_LIBRARY=$BLDR_OPENMPI_LIB_PATH/libmpi.a"
pkg_cfg="$pkg_cfg:-DMPI_EXTRA_LIBRARY=$BLDR_OPENMPI_LIB_PATH/libopen-pal.a"

pkg_cfg="$pkg_cfg:-DHDF5_DIR=$BLDR_PHDF5_BASE_PATH"
pkg_cfg="$pkg_cfg:-DHDF5_CXX_COMPILER_EXECUTABLE=$BLDR_PHDF5_BIN_PATH/h5c++"
pkg_cfg="$pkg_cfg:-DHDF5_C_COMPILER_EXECUTABLE=$BLDR_PHDF5_BIN_PATH/h5cc"
pkg_cfg="$pkg_cfg:-DHDF5_C_INCLUDE_DIR=$BLDR_PHDF5_INCLUDE_PATH"
pkg_cfg="$pkg_cfg:-DHDF5_LIBRARIES=$BLDR_PHDF5_LIB_PATH/libhdf5.a"
pkg_cfg="$pkg_cfg:-DHDF5_hdf5_LIBRARY=$BLDR_PHDF5_LIB_PATH/libhdf5.a"
pkg_cfg="$pkg_cfg:-DHDF5_hdf5_hl_LIBRARY=$BLDR_PHDF5_LIB_PATH/libhdf5_hl.a"
pkg_cfg="$pkg_cfg:-DHDF5_z_LIBRARY=$BLDR_ZLIB_LIB_PATH/libz.a"
pkg_cfg="$pkg_cfg:-DHDF5_sz_LIBRARY=$BLDR_SZIP_LIB_PATH/libsz.a"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_PARALLEL=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_ZLIB=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_HL_LIB=ON"


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
               --config      "$pkg_cfg"

####################################################################################################

