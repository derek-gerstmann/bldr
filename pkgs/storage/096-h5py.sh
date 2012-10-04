#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="h5py"

pkg_info="HDF5 for Python (h5py) is a general-purpose Python interface to the Hierarchical Data Format library, version 5."

pkg_desc="HDF5 for Python (h5py) is a general-purpose Python interface to the 
Hierarchical Data Format library, version 5.

HDF5 is a versatile, mature scientific software library designed for the fast, flexible storage 
of enormous amounts of data.

From a Python programmer's perspective, HDF5 provides a robust way to store data, organized by 
name in a tree-like fashion. 

You can create datasets (arrays on disk) hundreds of gigabytes in size, and perform random-access 
I/O on desired sections. Datasets are organized in a filesystem-like hierarchy using containers 
called groups, and accessed using the tradional POSIX /path/to/resource syntax."

pkg_vers_dft="2.0.1"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="python skip-compile skip-install"
pkg_reqs="hdf5 numpy"
pkg_uses="python"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                     \
    --category    "$pkg_ctry"        \
    --name        "$pkg_name"        \
    --version     "$pkg_vers_dft"    \
    --requires    "$pkg_reqs"        \
    --uses        "$pkg_uses"        \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="https://h5py.googlecode.com/files/$pkg_file"

    bldr_register_pkg                \
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
