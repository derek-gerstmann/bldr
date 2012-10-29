#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="phdf5"

pkg_default="1.8.9"
if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_variants=("1.8.9")
else
    pkg_variants=("1.6.10" "1.8.2" "1.8.9")
fi

pkg_info="The Parallel-HDF5 technology suite includes HDF5 compiled with MPI support to enable distributed parallel file access."

pkg_desc="The Parallel-HDF5 technology suite includes HDF5 compiled with MPI support to enable distributed parallel file access.

The Parallel-HDF5 technology suite includes:

* A versatile data model that can represent very complex data objects and a wide variety of metadata.
* A completely portable file format with no limit on the number or size of data objects in the collection.
* A software library that runs on a range of computational platforms, from laptops to massively parallel systems, and implements a high-level API with C, C++, Fortran 90, and Java interfaces.
* A rich set of integrated performance features that allow for access time and storage space optimizations.
* Tools and applications for managing, manipulating, viewing, and analyzing the data in the collection."

pkg_opts="configure enable-static enable-shared skip-xcode-config force-serial-build"
pkg_reqs="szip zlib openmpi gfortran"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="CC=mpicc FC=mpif90 "
pkg_cfg+="--enable-parallel "
pkg_cfg+="--enable-fortran"
pkg_cfg+="--enable-hl "
pkg_cfg+="--enable-filters=all "
pkg_cfg+="--enable-static-exec "
pkg_cfg+="--with-pthread=\"/usr\" "

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_cfg+="--enable-linux-lfs "
    pkg_cflags="$pkg_cflags -fPIC "
fi

pkg_cfg+="--with-szlib=\"$BLDR_SZIP_BASE_PATH\" "
pkg_cfg+="--with-zlib=\"$BLDR_ZLIB_BASE_PATH\" "

hdf5_cfg="$pkg_cfg"

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_name="phdf5"
    pkg_file="hdf5-$pkg_vers.tar.gz"
    pkg_urls="http://www.hdfgroup.org/ftp/HDF5/releases/$pkg_name-$pkg_vers/src/$pkg_file"

    #
    # phdf5 - parallel HDF5 (using MPI collective IO)
    #
    pkg_name="phdf5"
    pkg_cfg="$hdf5_cfg"
    bldr_register_pkg                  \
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

    #
    # phdf5 - parallel HDF5 w/v1.6 legacy API methods
    #
    if [[ $(echo $pkg_vers | grep -m1 -c '^1.8' ) > 0 ]]
    then

        pkg_name="phdf5-16"
        pkg_cfg="$hdf5_cfg --with-default-api-version=v16"

        bldr_register_pkg                  \
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
    fi
done

####################################################################################################

