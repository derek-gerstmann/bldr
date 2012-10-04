#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="jhi5"

pkg_info="The Java HD5 Interface (JHI5) is a Java package that wraps around the HDF5 library."

pkg_desc="The Java HD5 Interface (JHI5) is a Java package that wraps around the HDF5 library.

The HDF Object Package is a Java package that provides an object-oriented interface 
to HDF data objects. The package offers a common API to access both HDF4 and HDF5 files.

The HDF Object Package does not provide a one-to-one mapping from Java methods to routines 
in the standard HDF4 and HDF5 libraries. The one-to-one mappings are provided via the HDF 
Java Native Interface products Java HDF Interface (JHI) and Java HDF5 Interface (JHI5). 
The HDF Object Package wraps these direct mappings with a higher level object model.

The HDF Object Package, ncsa.hdf.object, provides classes that reflect the fundamental 
objects of the two HDF formats. Fundamental objects from HDF4 (group, multi-dimensional 
array, raster image, vdata, and annotation) and HDF5 (group and dataset) are presented 
as Java classes in the HDF Object Package."

pkg_vers_dft="2.8"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_reqs="szip zlib libjpeg hdf5"
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


pkg_cfg=""
pkg_cfg="$pkg_cfg --with-hdf5=$BLDR_HDF5_INCLUDE_PATH,$BLDR_HDF5_LIB_PATH"
pkg_cfg="$pkg_cfg --with-hdf5=$BLDR_HDF5_INCLUDE_PATH,$BLDR_HDF5_LIB_PATH"
pkg_cfg="$pkg_cfg --with-libsz=$BLDR_SZIP_INCLUDE_PATH,$BLDR_SZIP_LIB_PATH"
pkg_cfg="$pkg_cfg --with-libz=$BLDR_ZLIB_INCLUDE_PATH,$BLDR_ZLIB_LIB_PATH"
pkg_cfg="$pkg_cfg --with-libjpeg=$BLDR_LIBJPEG_INCLUDE_PATH,$BLDR_LIBJPEG_LIB_PATH"

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    uname_vers=$(uname -r)
    pkg_cfg="$pkg_cfg -build=i686-apple-darwin${uname_vers}"
fi

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="hdf-java-$pkg_vers-src.tar"
    pkg_urls="http://www.hdfgroup.org/ftp/HDF5/hdf-java/src/$pkg_file"

    bldr_register_pkg                  \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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
