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

pkg_info="NetCDF is a set of software libraries and self-describing, machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data."

pkg_desc="NetCDF is a set of software libraries and self-describing, machine-independent data 
formats that support the creation, access, and sharing of array-oriented scientific data.

NetCDF (network Common Data Form) is a set of interfaces for array-oriented data access and 
a freely-distributed collection of data access libraries for C, Fortran, C++, Java, 
and other languages. The netCDF libraries support a machine-independent format for 
representing scientific data. Together, the interfaces, libraries, and format support 
the creation, access, and sharing of scientific data."

pkg_vers_dft="4.2.1.1"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_reqs="szip zlib hdf5"
pkg_uses="$pkg_reqs"

pkg_cfg="--enable-netcdf4 --enable-mmap"

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://www.unidata.ucar.edu/downloads/netcdf/ftp/$pkg_file"

     bldr_register_pkg                 \
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
