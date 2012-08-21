#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="field3d"
pkg_vers="1.3.2"

pkg_info="Field3D is an open source library for storing voxel data on disk and in memory."

pkg_desc="Field3D is an open source library for storing voxel data on disk and in memory. 
It provides C++ classes that handle in-memory storage and a file format based on HDF5 that 
allows the C++ objects to be written to and read from disk."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="git://github.com/imageworks/Field3D.git"
pkg_opts="cmake"
pkg_reqs=""
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs bzip2/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs szip/latest"
pkg_reqs="$pkg_reqs hdf5/latest"
pkg_reqs="$pkg_reqs boost/latest"
pkg_reqs="$pkg_reqs glew/latest"
pkg_reqs="$pkg_reqs lcms2/latest"
pkg_reqs="$pkg_reqs ilmbase/latest"
pkg_reqs="$pkg_reqs openexr/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_reqs="$pkg_reqs libjpeg/latest"
pkg_reqs="$pkg_reqs libtiff/latest"
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

ilm_base="$BLDR_ILMBASE_BASE_PATH"
exr_base="$BLDR_OPENEXR_BASE_PATH"
tiff_base="$BLDR_LIBTIFF_BASE_PATH"
png_base="$BLDR_LIBPNG_BASE_PATH"
jpeg_base="$BLDR_LIBJPEG_BASE_PATH"
jp2k_base="$BLDR_OPENJPEG_BASE_PATH"
zlib_base="$BLDR_ZLIB_BASE_PATH"
szip_base="$BLDR_SZIP_BASE_PATH"
glew_base="$BLDR_GLEW_BASE_PATH"
hdf_base="$BLDR_HDF5_BASE_PATH"

hdf_libs="$BLDR_HDF5_LIB_PATH/libhdf5.a"
hdf_libs="$hdf_libs\;$BLDR_HDF5_LIB_PATH/libhdf5_hl.a"
hdf_libs="$hdf_libs\;$BLDR_HDF5_LIB_PATH/libhdf5_cpp.a"
hdf_libs="$hdf_libs\;$BLDR_ZLIB_LIB_PATH/libz.a"
hdf_libs="$hdf_libs\;$BLDR_SZIP_LIB_PATH/libsz.a"

boost_base="$BLDR_BOOST_BASE_PATH"
boost_link="$BLDR_BOOST_LIB_PATH/libboost_program_options.a"
boost_link="$boost_link $BLDR_BOOST_LIB_PATH/libboost_thread.a"
boost_link="$boost_link $BLDR_BOOST_LIB_PATH/libboost_system.a"

boost_libs="$BLDR_BOOST_LIB_PATH/libboost_program_options.a"
boost_libs="$boost_libs\;$BLDR_BOOST_LIB_PATH/libboost_thread.a"
boost_libs="$boost_libs\;$BLDR_BOOST_LIB_PATH/libboost_system.a"
boost_libs="$boost_libs\;$BLDR_BOOST_LIB_PATH/libboost_filesystem.a"
boost_libs="$boost_libs\;$BLDR_BOOST_LIB_PATH/libboost_python.a"
boost_libs="$boost_libs\;$BLDR_BOOST_LIB_PATH/libboost_regex.a"

pkg_ldflags="$pkg_ldflags:$boost_libs"

####################################################################################################

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg -DCMAKE_EXE_LINKER_FLAGS='$mpi_link $boost_link'"
pkg_cfg="$pkg_cfg -DCMAKE_MODULE_LINKER_FLAGS='$mpi_link $boost_link'"
pkg_cfg="$pkg_cfg -DCMAKE_C_FLAGS='-I$mpi_base/include -I$boost_base/include'"
pkg_cfg="$pkg_cfg -DCMAKE_CXX_FLAGS='-I$mpi_base/include -I$boost_base/include -L$boost_base/lib'"
pkg_cfg="$pkg_cfg -DZLIB_INCLUDE_DIR=$zlib_base/include"
pkg_cfg="$pkg_cfg -DZLIB_LIBRARY=$zlib_base/lib/libz.a"
pkg_cfg="$pkg_cfg -DBoost_NO_SYSTEM_PATHS=TRUE"
pkg_cfg="$pkg_cfg -DBoost_DIR=$BLDR_BOOST_BASE_PATH"
pkg_cfg="$pkg_cfg -DBOOST_ROOT=$BLDR_BOOST_BASE_PATH"
pkg_cfg="$pkg_cfg -DBoost_DEBUG=ON"
pkg_cfg="$pkg_cfg -DBoost_FOUND=TRUE"
pkg_cfg="$pkg_cfg -DBoost_USE_STATIC_LIBS=ON"
pkg_cfg="$pkg_cfg -DBoost_USE_STATIC_RUNTIME=ON"
pkg_cfg="$pkg_cfg -DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DBoost_LIBRARY_DIRS=\"$BLDR_BOOST_LIB_PATH\""
pkg_cfg="$pkg_cfg -DBoost_FILESYSTEM_LIBRARY=\"$BLDR_BOOST_LIB_PATH/libboost_filesystem.a\""
pkg_cfg="$pkg_cfg -DBoost_PYTHON_LIBRARY=\"$BLDR_BOOST_LIB_PATH/libboost_python.a\""
pkg_cfg="$pkg_cfg -DBoost_REGEX_LIBRARY=\"$BLDR_BOOST_LIB_PATH/libboost_regex.a\""
pkg_cfg="$pkg_cfg -DBoost_SYSTEM_LIBRARY=\"$BLDR_BOOST_LIB_PATH/libboost_system.a\""
pkg_cfg="$pkg_cfg -DBoost_THREAD_LIBRARY=\"$BLDR_BOOST_LIB_PATH/libboost_thread.a\""
pkg_cfg="$pkg_cfg -DBoost_PROGRAM_OPTIONS_LIBRARY=\"$BLDR_BOOST_LIB_PATH/libboost_program_options.a\""
pkg_cfg="$pkg_cfg -DBoost_LIBRARIES=\"$boost_libs\""

pkg_cfg="$pkg_cfg -DIlmbase_Base_Dir=\"$BLDR_ILMBASE_BASE_PATH\""
pkg_cfg="$pkg_cfg -DILMBASE_INCLUDE_DIR=\"$BLDR_ILMBASE_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DILMBASE_HALF_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libHalf.a\""
pkg_cfg="$pkg_cfg -DILMBASE_IEX_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIex.a\""
pkg_cfg="$pkg_cfg -DILMBASE_IMATH_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libImath.a\""
pkg_cfg="$pkg_cfg -DILMBASE_ILMTHREAD_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIlmThread.a\""

pkg_cfg="$pkg_cfg -DHDF5_DIR=\"$BLDR_HDF5_BASE_PATH\""
pkg_cfg="$pkg_cfg -DHDF5_INCLUDE_DIR=\"$BLDR_HDF5_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DHDF5_INCLUDE_DIRS=\"$BLDR_HDF5_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DHDF5_LIBRARIES=\"$hdf_libs\""
pkg_cfg="$pkg_cfg -DHDF5_CXX_COMPILER_EXECUTABLE=\"$BLDR_HDF5_BIN_PATH/h5c++\""
pkg_cfg="$pkg_cfg -DHDF5_C_COMPILER_EXECUTABLE=\"$BLDR_HDF5_BIN_PATH/h5cc\""
pkg_cfg="$pkg_cfg -DHDF5_C_INCLUDE_DIR=\"$BLDR_HDF5_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DHDF5_hdf5_LIBRARY_RELEASE=\"$BLDR_HDF5_LIB_PATH/libhdf5.a\""
pkg_cfg="$pkg_cfg -DHDF5_hdf5_hl_LIBRARY_RELEASE=\"$BLDR_HDF5_LIB_PATH/libhdf5_hl.a\""
pkg_cfg="$pkg_cfg -DHDF5_hdf5_cpp_LIBRARY_RELEASE=\"$BLDR_HDF5_LIB_PATH/libhdf5_cpp.a\""
pkg_cfg="$pkg_cfg -DHDF5_z_LIBRARY_RELEASE=\"$BLDR_ZLIB_LIB_PATH/libz.a\""
pkg_cfg="$pkg_cfg -DHDF5_sz_LIBRARY_RELEASE=\"$BLDR_SZIP_LIB_PATH/libsz.a\""
pkg_cfg="$pkg_cfg -DSZIP_INCLUDE_DIR=\"$BLDR_SZIP_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DSZIP_LIBRARY=\"$BLDR_SZIP_LIB_PATH/libsz.a\""


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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_src"


