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
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="internal/zlib internal/bzip2 internal/libxml2"
dep_list="$dep_list storage/szip storage/hdf5"
dep_list="$dep_list developer/boost graphics/glew"
dep_list="$dep_list imaging/lcms2 imaging/ilmbase imaging/openexr"
dep_list="$dep_list imaging/libpng imaging/libjpeg imaging/libtiff"
for dep_pkg in $dep_list
do
     pkg_req_name=$(echo "$dep_pkg" | sed 's/.*\///g' )
     pkg_reqs="$pkg_reqs $pkg_req_name/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done
pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest $pkg_reqs"

####################################################################################################

ilm_base="$BLDR_LOCAL_PATH/imaging/ilmbase/latest"
exr_base="$BLDR_LOCAL_PATH/imaging/openexr/latest"
tiff_base="$BLDR_LOCAL_PATH/imaging/libtiff/latest"
png_base="$BLDR_LOCAL_PATH/imaging/libpng/latest"
jpeg_base="$BLDR_LOCAL_PATH/imaging/libjpeg/latest"
jp2k_base="$BLDR_LOCAL_PATH/imaging/openjpeg/latest"
zlib_base="$BLDR_LOCAL_PATH/internal/zlib/latest"
szip_base="$BLDR_LOCAL_PATH/storage/szip/latest"
glew_base="$BLDR_LOCAL_PATH/graphics/glew/latest"

hdf_base="$BLDR_LOCAL_PATH/storage/hdf5/latest"
hdf_libs="$hdf_base/lib/libhdf5.a"
hdf_libs="$hdf_libs\;$hdf_base/lib/libhdf5_hl.a"
hdf_libs="$hdf_libs\;$hdf_base/lib/libhdf5_cpp.a"
hdf_libs="$hdf_libs\;$zlib_base/lib/libz.a"
hdf_libs="$hdf_libs\;$szip_base/lib/libsz.a"

boost_base="$BLDR_LOCAL_PATH/developer/boost/latest"
boost_link="$boost_base/lib/libboost_program_options.a"
boost_link="$boost_link $boost_base/lib/libboost_thread.a"
boost_link="$boost_link $boost_base/lib/libboost_system.a"
boost_libs="$boost_base/lib/libboost_program_options.a"
boost_libs="$boost_libs\;$boost_base/lib/libboost_thread.a"
boost_libs="$boost_libs\;$boost_base/lib/libboost_system.a"

####################################################################################################

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DCMAKE_EXE_LINKER_FLAGS='$boost_link'"
pkg_cfg="$pkg_cfg:-DCMAKE_MODULE_LINKER_FLAGS='$boost_link'"
pkg_cfg="$pkg_cfg:-DCMAKE_C_FLAGS='-I$boost_base/include'"
pkg_cfg="$pkg_cfg:-DCMAKE_CXX_FLAGS='-I$boost_base/include -L$boost_base/lib'"

pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=$zlib_base/include"
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=$zlib_base/lib/libz.a"

pkg_cfg="$pkg_cfg:-DBoost_NO_SYSTEM_PATHS=TRUE"
pkg_cfg="$pkg_cfg:-DBoost_DIR=$boost_base"
pkg_cfg="$pkg_cfg:-DBOOST_ROOT=$boost_base"
pkg_cfg="$pkg_cfg:-DBoost_DEBUG=ON"
pkg_cfg="$pkg_cfg:-DBoost_FOUND=TRUE"
pkg_cfg="$pkg_cfg:-DBoost_USE_STATIC_LIBS=ON"
pkg_cfg="$pkg_cfg:-DBoost_USE_STATIC_RUNTIME=ON"
pkg_cfg="$pkg_cfg:-DBoost_INCLUDE_DIR=$boost_base/include"
pkg_cfg="$pkg_cfg:-DBoost_LIBRARY_DIRS=$boost_base/lib/$os_name"
pkg_cfg="$pkg_cfg:-DBoost_FILESYSTEM_LIBRARY=$boost_base/lib/libboost_filesystem.a"
pkg_cfg="$pkg_cfg:-DBoost_PYTHON_LIBRARY=$boost_base/lib/libboost_python.a"
pkg_cfg="$pkg_cfg:-DBoost_REGEX_LIBRARY=$boost_base/lib/libboost_regex.a"
pkg_cfg="$pkg_cfg:-DBoost_SYSTEM_LIBRARY=$boost_base/lib/libboost_system.a"
pkg_cfg="$pkg_cfg:-DBoost_THREAD_LIBRARY=$boost_base/lib/libboost_thread.a"
pkg_cfg="$pkg_cfg:-DBoost_PROGRAM_OPTIONS_LIBRARY=$boost_base/lib/libboost_program_options.a"
pkg_cfg="$pkg_cfg:-DBoost_LIBRARIES=$boost_libs"
pkg_cfg="$pkg_cfg:-DBOOST_INCLUDEDIR=$boost_base/include"
pkg_cfg="$pkg_cfg:-DBOOST_LIBRARYDIR=$boost_base/lib"

pkg_cfg="$pkg_cfg:-DIlmbase_Base_Dir=$ilm_base"
pkg_cfg="$pkg_cfg:-DILMBASE_INCLUDE_DIR=$ilm_base/include"
pkg_cfg="$pkg_cfg:-DILMBASE_HALF_LIBRARIES=$ilm_base/lib/libHalf.a"
pkg_cfg="$pkg_cfg:-DILMBASE_IEX_LIBRARIES=$ilm_base/lib/libIex.a"
pkg_cfg="$pkg_cfg:-DILMBASE_IMATH_LIBRARIES=$ilm_base/lib/libImath.a"
pkg_cfg="$pkg_cfg:-DILMBASE_ILMTHREAD_LIBRARIES=$ilm_base/lib/libIlmThread.a"

pkg_cfg="$pkg_cfg:-DHDF5_DIR=$hdf_base"
pkg_cfg="$pkg_cfg:-DHDF5_INCLUDE_DIR=$hdf_base/include"
pkg_cfg="$pkg_cfg:-DHDF5_INCLUDE_DIRS=$hdf_base/include"
pkg_cfg="$pkg_cfg:-DHDF5_LIBRARIES=$hdf_libs"
pkg_cfg="$pkg_cfg:-DHDF5_CXX_COMPILER_EXECUTABLE=$hdf_base/bin/h5c++"
pkg_cfg="$pkg_cfg:-DHDF5_C_COMPILER_EXECUTABLE=$hdf_base/bin/h5cc"
pkg_cfg="$pkg_cfg:-DHDF5_C_INCLUDE_DIR=$hdf_base/include"
pkg_cfg="$pkg_cfg:-DHDF5_hdf5_LIBRARY_RELEASE=$hdf_base/lib/libhdf5.a"
pkg_cfg="$pkg_cfg:-DHDF5_hdf5_hl_LIBRARY_RELEASE=$hdf_base/lib/libhdf5_hl.a"
pkg_cfg="$pkg_cfg:-DHDF5_hdf5_cpp_LIBRARY_RELEASE=$hdf_base/lib/libhdf5_cpp.a"
pkg_cfg="$pkg_cfg:-DHDF5_z_LIBRARY_RELEASE=$zlib_base/lib/libz.a"
pkg_cfg="$pkg_cfg:-DHDF5_sz_LIBRARY_RELEASE=$szip_base/lib/libsz.a"

pkg_cfg="$pkg_cfg:-DSZIP_INCLUDE_DIR=$szip_base/include"
pkg_cfg="$pkg_cfg:-DSZIP_LIBRARY=$szip_base/lib/libsz.a"


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


