#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="cluster"
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
pkg_reqs="szip/latest zlib/latest mxml/latest phdf5/latest pnetcdf/latest"
pkg_uses="m4/latest autoconf/latest automake/latest"

pkg_cflags=""
pkg_ldflags=""

####################################################################################################

pkg_cfg="--disable-fortran"
pkg_cfg="$pkg_cfg --with-mxml=$BLDR_LOCAL_PATH/developer/mxml/latest"

if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
then
     pkg_reqs="$pkg_reqs openmpi/latest"     
     pkg_cflags="-I$BLDR_LOCAL_PATH/cluster/openmpi/latest/include"
     pkg_ldflags="-L$BLDR_LOCAL_PATH/cluster/openmpi/latest/lib"
else
#     pkg_cfg="$pkg_cfg --with-infinband=$BLDR_LOCAL_PATH/network/ofed/latest"
fi

pkg_cflags="$pkg_cflags -I$BLDR_LOCAL_PATH/storage/phdf5/latest/include"
pkg_ldflags="$pkg_ldflags -L$BLDR_LOCAL_PATH/storage/phdf5/latest/lib"

pkg_cflags="$pkg_cflags -I$BLDR_LOCAL_PATH/storage/pnetcdf/latest/include"
pkg_ldflags="$pkg_ldflags -L$BLDR_LOCAL_PATH/storage/pnetcdf/latest/lib"

pkg_cfg="$pkg_cfg --with-phdf5=$BLDR_LOCAL_PATH/storage/phdf5/latest"
pkg_cfg="$pkg_cfg --with-phdf5-incdir=$BLDR_LOCAL_PATH/storage/phdf5/latest/include"
pkg_cfg="$pkg_cfg --with-phdf5-libdir=$BLDR_LOCAL_PATH/storage/phdf5/latest/lib"

pkg_cfg="$pkg_cfg --with-nc4par=$BLDR_LOCAL_PATH/storage/pnetcdf/latest"
pkg_cfg="$pkg_cfg --with-nc4par-incdir=$BLDR_LOCAL_PATH/storage/pnetcdf/latest/include"
pkg_cfg="$pkg_cfg --with-nc4par-libdir=$BLDR_LOCAL_PATH/storage/pnetcdf/latest/lib"

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

