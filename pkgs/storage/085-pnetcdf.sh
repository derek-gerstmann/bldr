#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="pnetcdf"

pkg_default="4.2.1.1"
pkg_variants=("4.2.1.1")

pkg_info="NetCDF is a set of software libraries and self-describing, machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data."

pkg_desc="NetCDF is a set of software libraries and self-describing, machine-independent data 
formats that support the creation, access, and sharing of array-oriented scientific data.

NetCDF (network Common Data Form) is a set of interfaces for array-oriented data access and 
a freely-distributed collection of data access libraries for C, Fortran, C++, Java, 
and other languages. The netCDF libraries support a machine-independent format for 
representing scientific data. Together, the interfaces, libraries, and format support 
the creation, access, and sharing of scientific data."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="szip zlib phdf5 openmpi gfortran"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                  \
  --category    "$pkg_ctry"       \
  --name        "$pkg_name"       \
  --version     "$pkg_default"    \
  --requires    "$pkg_reqs"       \
  --uses        "$pkg_uses"       \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags="-I$BLDR_PHDF5_INCLUDE_PATH"
pkg_ldflags="-L$BLDR_PHDF5_LIB_PATH"

pkg_cfg="CC=mpicc FC=mpif90"
pkg_cfg+="--enable-netcdf4 --enable-mmap"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="netcdf-$pkg_vers.tar.gz"
    pkg_urls="http://www.unidata.ucar.edu/downloads/netcdf/ftp/$pkg_file"

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
