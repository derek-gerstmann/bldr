#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="netcdf"
pkg_vers="4.2.1"

pkg_info="NetCDF is a set of software libraries and self-describing, machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data."

pkg_desc="NetCDF is a set of software libraries and self-describing, machine-independent data 
formats that support the creation, access, and sharing of array-oriented scientific data.

NetCDF (network Common Data Form) is a set of interfaces for array-oriented data access and 
a freely-distributed collection of data access libraries for C, Fortran, C++, Java, 
and other languages. The netCDF libraries support a machine-independent format for 
representing scientific data. Together, the interfaces, libraries, and format support 
the creation, access, and sharing of scientific data."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.unidata.ucar.edu/downloads/netcdf/ftp/$pkg_file"
pkg_opts="configure"
pkg_reqs="szip/latest zlib/latest hdf5/latest"
pkg_uses="$pkg_reqs"

pkg_cflags="-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/storage/szip/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/storage/szip/latest/lib"

pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/storage/hdf5/latest/include"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/storage/hdf5/latest/lib"

pkg_cfg="--enable-netcdf4 --enable-mmap"

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

