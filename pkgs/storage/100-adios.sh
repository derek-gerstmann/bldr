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

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://users.nccs.gov/~pnorbert/$pkg_file"
pkg_opts="configure"
pkg_reqs="szip/latest zlib/latest mxml/latest openmpi/1.6 phdf5/latest pnetcdf/latest"
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

####################################################################################################


if [[ -x $(which "mpif90") ]]; then
     pkg_cfg="$pkg_cfg FC=mpif90"
     pkg_cfg="$pkg_cfg --enable-fortran"
else
     pkg_cfg="--disable-fortran"
fi

pkg_cfg="$pkg_cfg --with-mxml=\"$BLDR_MXML_BASE_PATH\""

pkg_cfg="$pkg_cfg --with-phdf5=\"$BLDR_PHDF5_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-phdf5-incdir=\"$BLDR_PHDF5_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-phdf5-libdir=\"$BLDR_PHDF5_LIB_PATH\""

pkg_cfg="$pkg_cfg --with-nc4par=\"$BLDR_PNETCDF_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-nc4par-incdir=\"$BLDR_PNETCDF_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-nc4par-libdir=\"$BLDR_PNETCDF_LIB_PATH\""

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

