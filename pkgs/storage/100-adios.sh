#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="adios"
pkg_vers="1.4.0"

pkg_info="The Adaptable IO System (ADIOS) provides a simple, flexible way for scientists to describe the data in their code that may need to be written, read, or processed outside of the running simulation."

pkg_desc="The Adaptable IO System (ADIOS) provides a simple, flexible way for 
scientists to describe the data in their code that may need to be written, read, 
or processed outside of the running simulation. By providing an external to the 
code XML file describing the various elements, their types, and how you wish 
to process them this run, the routines in the host code (either Fortran or C) 
can transparently change how they process the data."

pkg_opts="configure enable-static enable-shared"
pkg_reqs="$pkg_reqs szip"
pkg_reqs="$pkg_reqs zlib"
pkg_reqs="$pkg_reqs python"
pkg_reqs="$pkg_reqs mxml"
pkg_reqs="$pkg_reqs openmpi"
pkg_reqs="$pkg_reqs hdf5" 
pkg_reqs="$pkg_reqs phdf5"
pkg_reqs="$pkg_reqs netcdf"
pkg_reqs="$pkg_reqs pnetcdf"
pkg_reqs="$pkg_reqs gfortran"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                  \
  --category    "$pkg_ctry"       \
  --name        "$pkg_name"       \
  --version     "$pkg_vers_dft"   \
  --requires    "$pkg_reqs"       \
  --uses        "$pkg_uses"       \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################

export MPICC="\"$BLDR_OPENMPI_BIN_PATH\mpicc\""
export MPICXX="\"$BLDR_OPENMPI_BIN_PATH\mpicxx\""
export MPIF90="\"$BLDR_OPENMPI_BIN_PATH\mpif90\""

pkg_cfg="$pkg_cfg --enable-fortran"
pkg_cfg="$pkg_cfg --with-mxml=\"$BLDR_MXML_BASE_PATH\""

pkg_cfg="$pkg_cfg --with-hdf5=\"$BLDR_HDF5_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-hdf5-incdir=\"$BLDR_HDF5_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-hdf5-libdir=\"$BLDR_HDF5_LIB_PATH\""

pkg_cfg="$pkg_cfg --with-phdf5=\"$BLDR_PHDF5_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-phdf5-incdir=\"$BLDR_PHDF5_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-phdf5-libdir=\"$BLDR_PHDF5_LIB_PATH\""

pkg_cfg="$pkg_cfg --with-netcdf=\"$BLDR_NETCDF_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-netcdf-incdir=\"$BLDR_NETCDF_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-netcdf-libdir=\"$BLDR_NETCDF_LIB_PATH\""

pkg_cfg="$pkg_cfg --with-nc4par=\"$BLDR_PNETCDF_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-nc4par-incdir=\"$BLDR_PNETCDF_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-nc4par-libdir=\"$BLDR_PNETCDF_LIB_PATH\""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    if [[ -f "/usr/lib64/libibverbs.so" ]]
    then
        pkg_cfg="$pkg_cfg --with-infiniband=/usr/lib64"
    fi
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://users.nccs.gov/~pnorbert/$pkg_file"

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
