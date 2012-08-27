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
pkg_vers="4.2.1.1"

pkg_info="NetCDF is a set of software libraries and self-describing, machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data."

pkg_desc="NetCDF is a set of software libraries and self-describing, machine-independent data 
formats that support the creation, access, and sharing of array-oriented scientific data.

NetCDF (network Common Data Form) is a set of interfaces for array-oriented data access and 
a freely-distributed collection of data access libraries for C, Fortran, C++, Java, 
and other languages. The netCDF libraries support a machine-independent format for 
representing scientific data. Together, the interfaces, libraries, and format support 
the creation, access, and sharing of scientific data."

pkg_file="netcdf-$pkg_vers.tar.gz"
pkg_urls="http://www.unidata.ucar.edu/downloads/netcdf/ftp/$pkg_file"
pkg_opts="configure"
pkg_reqs="szip/latest zlib/latest phdf5/latest openmpi/1.6"
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

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_cfg="$pkg_cfg:-DMPI_INCLUDE_PATH=\"$BLDR_OPENMPI_INCLUDE_PATH\""
else
    pkg_cflags="$pkg_cflags:-I/opt/openmpi/1.6/include"
    pkg_ldflags="$pkg_ldflags:-L/opt/openmpi/1.6/lib"
    pkg_cfg="$pkg_cfg:-DMPI_INCLUDE_PATH=/opt/openmpi/1.6/include"
fi

####################################################################################################

pkg_name="pnetcdf"
pkg_cfg="--enable-parallel --enable-netcdf4 --enable-mmap"

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

