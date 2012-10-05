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

pkg_default="trunk"
pkg_variants=("trunk")

pkg_info="Field3D is an open source library for storing voxel data on disk and in memory."

pkg_desc="Field3D is an open source library for storing voxel data on disk and in memory. 
It provides C++ classes that handle in-memory storage and a file format based on HDF5 that 
allows the C++ objects to be written to and read from disk."

pkg_opts="cmake"

pkg_reqs="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="libxml2 "
pkg_reqs+="szip "
pkg_reqs+="hdf5 "
pkg_reqs+="boost "
pkg_reqs+="glew "
pkg_reqs+="lcms2 "
pkg_reqs+="ilmbase "
pkg_reqs+="openexr "
pkg_reqs+="libpng "
pkg_reqs+="libjpeg "
pkg_reqs+="libtiff "
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

hdf_libs="$BLDR_HDF5_LIB_PATH/libhdf5.a"
hdf_libs="$hdf_libs\;$BLDR_HDF5_LIB_PATH/libhdf5_hl.a"
hdf_libs="$hdf_libs\;$BLDR_HDF5_LIB_PATH/libhdf5_cpp.a"
hdf_libs="$hdf_libs\;$BLDR_ZLIB_LIB_PATH/libz.a"
hdf_libs="$hdf_libs\;$BLDR_SZIP_LIB_PATH/libsz.a"
pkg_ldflags="$pkg_ldflags:$boost_libs"

####################################################################################################

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1 "
pkg_cfg+="-DCMAKE_C_FLAGS='-I$BLDR_OPENMPI_INCLUDE_PATH -I$BLDR_BOOST_INCLUDE_PATH' "
pkg_cfg+="-DCMAKE_CXX_FLAGS='-I$BLDR_OPENMPI_INCLUDE_PATH -I$BLDR_BOOST_INCLUDE_PATH -L$BLDR_BOOST_LIB_PATH' "
pkg_cfg+="-DZLIB_INCLUDE_DIR=$BLDR_ZLIB_INCLUDE_PATH "
pkg_cfg+="-DZLIB_LIBRARY=$BLDR_ZLIB_LIB_PATH/libz.a "

pkg_cfg+="-DBoost_NO_SYSTEM_PATHS=ON "
pkg_cfg+="-DBoost_NO_BOOST_CMAKE=ON "
pkg_cfg+="-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\" "
pkg_cfg+="-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\" "
pkg_cfg+="-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\" "
# pkg_cfg+="-DBoost_DEBUG=OFF "
pkg_cfg+="-DBoost_FOUND=TRUE "
pkg_cfg+="-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\" "
pkg_cfg+="-DBoost_LIBRARY_DIRS=\"$BLDR_BOOST_LIB_PATH\" "

pkg_cfg+="-DIlmbase_Base_Dir=\"$BLDR_ILMBASE_BASE_PATH\" "
pkg_cfg+="-DILMBASE_INCLUDE_DIR=\"$BLDR_ILMBASE_INCLUDE_PATH\" "
pkg_cfg+="-DILMBASE_HALF_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libHalf.a\" "
pkg_cfg+="-DILMBASE_IEX_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIex.a\" "
pkg_cfg+="-DILMBASE_IMATH_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libImath.a\" "
pkg_cfg+="-DILMBASE_ILMTHREAD_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIlmThread.a\" "

pkg_cfg+="-DHDF5_DIR=\"$BLDR_HDF5_BASE_PATH\" "
pkg_cfg+="-DHDF5_INCLUDE_DIR=\"$BLDR_HDF5_INCLUDE_PATH\" "
pkg_cfg+="-DHDF5_INCLUDE_DIRS=\"$BLDR_HDF5_INCLUDE_PATH\" "
pkg_cfg+="-DHDF5_LIBRARIES=\"$hdf_libs\" "
pkg_cfg+="-DHDF5_CXX_COMPILER_EXECUTABLE=\"$BLDR_HDF5_BIN_PATH/h5c++\" "
pkg_cfg+="-DHDF5_C_COMPILER_EXECUTABLE=\"$BLDR_HDF5_BIN_PATH/h5cc\" "
pkg_cfg+="-DHDF5_C_INCLUDE_DIR=\"$BLDR_HDF5_INCLUDE_PATH\" "
pkg_cfg+="-DHDF5_hdf5_LIBRARY_RELEASE=\"$BLDR_HDF5_LIB_PATH/libhdf5.a\" "
pkg_cfg+="-DHDF5_hdf5_hl_LIBRARY_RELEASE=\"$BLDR_HDF5_LIB_PATH/libhdf5_hl.a\" "
pkg_cfg+="-DHDF5_hdf5_cpp_LIBRARY_RELEASE=\"$BLDR_HDF5_LIB_PATH/libhdf5_cpp.a\" "
pkg_cfg+="-DHDF5_z_LIBRARY_RELEASE=\"$BLDR_ZLIB_LIB_PATH/libz.a\" "
pkg_cfg+="-DHDF5_sz_LIBRARY_RELEASE=\"$BLDR_SZIP_LIB_PATH/libsz.a\" "
pkg_cfg+="-DSZIP_INCLUDE_DIR=\"$BLDR_SZIP_INCLUDE_PATH\" "
pkg_cfg+="-DSZIP_LIBRARY=\"$BLDR_SZIP_LIB_PATH/libsz.a\" "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
    pkg_urls="git://github.com/imageworks/Field3D.git"

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
